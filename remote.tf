data "terraform_remote_state" "burkey-aws-core" {
  backend = "remote"
  hostname = "app.terraform.io"

  config = {
    organization = "burkey"

    workspaces = {
      name = "terraform-aws-core"
    }
  }
}