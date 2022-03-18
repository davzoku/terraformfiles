resource "local_file" "lifecycle" {
    filename = "testing_lifecycle.txt"
    content = "lifecycle test2"

    lifecycle {
        # create_before_destroy =  true
        
        # does not prevent terraform destroy command
        # prevent_destroy = true

        ignore_changes = [
            content
        ]
    }
  
}