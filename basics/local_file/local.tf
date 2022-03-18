resource "local_file" "create-a-file" {
    filename = "hello-world.txt"
    # content = "this is hello world!!"
    sensitive_content = "this is hidden world!!"
}