resource "local_file" "name" {
    filename = var.users[count.index]
    sensitive_content = var.content
    count = length(var.users)
}
