data "terraform_remote_state" "burkey-aws-core" {
  backend = "remote"

  config = {
    organization = "burkey"

    workspaces = {
      name = "terraform-aws-core"
    }
  }
}