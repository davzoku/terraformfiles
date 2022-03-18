resource "local_file" "whale" {
    filename = "whale"

    depends_on = [
        local_file.krill
    ]
}

resource "local_file" "krill" {
    filename = "/root/krill"
}