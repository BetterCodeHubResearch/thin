require 'test_helper'

class WorkerTest < IntegrationTestCase
  def test_crash
    thin
    
    get "/crash"
    
    assert_status 500
  end
  
  def test_crash_in_production
    thin :env => "production"
    
    assert_raise(EOFError) { get "/crash" }
  end
  
  def test_restart_worker_on_exit
    thin :workers => 1
    
    assert_raise(EOFError) { get "/exit" }
    get "/"
    
    assert_status 200
  end
  
  def test_timeout
    thin :timeout => 1
    
    assert_raise(EOFError) { get "/sleep?sec=2" }
  end
end