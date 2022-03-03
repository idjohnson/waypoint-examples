project = "example-java"
#runner {
#  profile = "prod"
#}

variable "regcred_secret" {
  default     = "regcred"
  type        = string
  description = "The existing secret name inside Kubernetes for authenticating to the container registry"
}

runner {
  enabled = true

#  target_labels = {
#    "env" = {
#      "default" = "test"
#      "prod" = "prod"
#    }[workspace.name]
#  }
  data_source "git" {
    url              = "https://github.com/example/example.git"
    username = "git"
    password = var.github_token
  }
}
#variable "registry_username" {
#  default     = ""
#  type        = string
#  description = "username for container registry"
#}
#
#variable "registry_password" {
#  default     = ""
#  type        = string
#  description = "password for registry" // don't hack me plz
#}

app "example-java" {
#  runner {
#    profile = "dev"
#    target_labels = {
#    "env" = {
#        "default"  = "test"
#        "prod" = "prod"
#      }[workspace.name], 
#  }
#  }
  build {
    use "pack" {
      builder="gcr.io/buildpacks/builder:latest"
    }
    registry {
#    use "docker" {
#  	image = "example-java"
#  	tag = "1"
#  	username = var.registry_username
#  	password = var.registry_password
#    }
      use "aws-ecr" {
        repository = "xx/tester"
        tag   = "1"
        region = "us-east-1"
      }
      #use "docker" {
      #  image = "example-java"
      #  tag   = "1"
      #  local = true
      #}
    }  
  }


  deploy {
    use "kubernetes" {
       context = "arn:aws:eks:us-east-1:797645259670:cluster/xx-test-prod"
#      context = {
#        "default" = "arn:aws:eks:us-east-2:797645259670:cluster/xx-test-dev"
#        "prod"    = "arn:aws:eks:us-east-1:797645259670:cluster/xx-test-prod"
#      }[workspace.name]

      namespace = "default"
      probe_path = "/"
      service_port = 8080
      image_secret = var.regcred_secret
    }
  }

  release {
    use "kubernetes" {
      node_port = 32000
    }
  }
}
