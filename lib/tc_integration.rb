require 'rubygems'
require 'win32ole'

include WIN32OLE::VARIANT

class String
  def strip_quotes
    gsub(/\A['"]+|['"]+\Z/, "").gsub("\\\\","\\")
  end
end

class TCUnit
    def initialize(name, tc)
        @framework, @unit = name.split(".")
        @integration = tc.integration
    end
    private
    def method_missing(meth, *args, &blk)
        @integration.RunRoutineEx(@framework, @unit, meth.to_s, WIN32OLE_VARIANT.new(args.map{|a| 
            a.is_a?(String) ? WIN32OLE_VARIANT.new(a, VT_BSTR) : WIN32OLE_VARIANT.new(a, VT_VARIANT|VT_BYREF)}
        ))
        sleep(1) while @integration.IsRunning 
        @integration.RoutineResult
    end
end


class TCLibrary
    def initialize(name, tc)
        @framework = name
        @tc = tc
        @units = {}
    end
    private
    def method_missing(meth, *args, &blk)
        raise("?") if(args.count > 0)
        @units[meth] ||= TCUnit.new(@framework + "." + meth.to_s, @tc)
    end
end

class Proj
	def initialize(proj_file)
		@tc = TC.new
		@integration = @tc.integration
		raise("Test Complete is already Running a test") if(@integration.IsRunning) 
		@suite = @integration.OpenProjectSuite(proj_file)
        @libraries ||={}
	end

	private
    def method_missing(meth, *args, &blk)
        raise("?") if(args.count > 0)
        @libraries[meth] ||= TCLibrary.new(meth.to_s, @tc)
    end
end

class TC
    def initialize
        @tc = TC.get_TC
    end

    def self.get_TC
        tc = get_OLE("TestComplete.TestCompleteApplication.9") unless tc
        tc = get_OLE("TestExecute.TestExecuteApplication.9") unless tc
        tc = get_OLE("TestComplete.TestCompleteApplication.8") unless tc
        tc = get_OLE("TestExecute.TestExecuteApplication.8") unless tc
        tc
    end
    
    def self.get_OLE(strAutomationEngine)
        begin
            tc = WIN32OLE.connect(strAutomationEngine)
        rescue WIN32OLERuntimeError
            begin
                tc = WIN32OLE.new(strAutomationEngine)
            rescue WIN32OLERuntimeError
            end
        end
        tc
    end

    def library(name)
        TCLibrary.new(name, @tc)
    end

    def method_missing(meth, *args, &blk)
       @tc.send(meth, *args, &blk)
    end

    def StartProcess(executable, parameter, timeout)
        shell = WIN32OLE.new('WScript.Shell')
        shell.Run("#{executable} \"#{parameter}\"")

        processName = executable.split(/[\/\\]/).last.split(/\./).first
        sys = @tc.GetObjectByName("Sys")
        x = Now + timeout

        begin
            process = sys.Find("ProcessName", processName)
        end while(!process.Exists && Now < x) 
        return process
    end
    
    def LaunchIe(url, timeout)
        executable = "C:\\Program Files (x86)\\Internet Explorer\\iexplore.exe"
        StartProcess(executable, url, timeout)
    end
end

