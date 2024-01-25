data "aws_ecr_authorization_token" "token" {}

resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.app_name}_${var.environment}_ecr_repo"
  tags = var.tags
  lifecycle {
    ignore_changes = all
  }

}

resource "null_resource" "local_image" {

  provisioner "local-exec" {
    # This is a 1-time execution to put a dummy image into the ECR repo, so 
    #    terraform provisioning works on the lambda function. Otherwise there is
    #    a chicken-egg scenario where the lambda can't be provisioned because no
    #    image exists in the ECR
    command     = <<EOF
      docker login ${data.aws_ecr_authorization_token.token.proxy_endpoint} -u AWS -p ${data.aws_ecr_authorization_token.token.password}
      docker pull alpine
      docker tag alpine ${aws_ecr_repository.ecr_repo.repository_url}:latest
      docker push ${aws_ecr_repository.ecr_repo.repository_url}:latest
      EOF
  }  
  depends_on = [
    data.aws_ecr_authorization_token.token
  ]
}