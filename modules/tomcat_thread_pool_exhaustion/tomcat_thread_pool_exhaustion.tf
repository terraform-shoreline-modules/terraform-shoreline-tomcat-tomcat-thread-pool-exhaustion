resource "shoreline_notebook" "tomcat_thread_pool_exhaustion" {
  name       = "tomcat_thread_pool_exhaustion"
  data       = file("${path.module}/data/tomcat_thread_pool_exhaustion.json")
  depends_on = [shoreline_action.invoke_tomcat_thread_update]
}

resource "shoreline_file" "tomcat_thread_update" {
  name             = "tomcat_thread_update"
  input_file       = "${path.module}/data/tomcat_thread_update.sh"
  md5              = filemd5("${path.module}/data/tomcat_thread_update.sh")
  description      = "Tune thread pools - Adjust the thread pool size and configuration to match the workload and resources available."
  destination_path = "/agent/scripts/tomcat_thread_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tomcat_thread_update" {
  name        = "invoke_tomcat_thread_update"
  description = "Tune thread pools - Adjust the thread pool size and configuration to match the workload and resources available."
  command     = "`chmod +x /agent/scripts/tomcat_thread_update.sh && /agent/scripts/tomcat_thread_update.sh`"
  params      = ["PATH_TO_TOMCAT"]
  file_deps   = ["tomcat_thread_update"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_thread_update]
}

