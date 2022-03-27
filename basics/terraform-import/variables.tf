variable "name" {
  type    = set(string)
  default = ["jade-webserver", "jade-lbr", "jade-app1", "jade-agent", "jade-app2"]

}
variable "ami" {
  default = "ami-0c9bfc21ac5bf10eb"
}
variable "instance_type" {
  default = "t2.nano"
}
variable "key_name" {
  default = "jade"

}
