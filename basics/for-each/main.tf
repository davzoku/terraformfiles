resource "local_file" "name" {
    filename = each.value
    for_each = toset(var.users)
    sensitive_content = var.content
  
}
