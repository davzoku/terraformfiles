resource "aws_s3_bucket_object" "upload" {
  bucket = "pixar-studios-2020"
  key    = "woody.jpg"
  source = "/root/woody.jpg"
}