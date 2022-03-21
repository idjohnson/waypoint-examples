project = "example-nodejs3"

runner {
  enabled = true

  data_source "git" {
     url = "https://github.com/idjohnson/waypoint-examples.git"
     ref = "main"
     path = "kubernetes/nodejs"
  }
}

app "example-nodejs3" {

  labels = {
    "service" = "example-nodejs",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "harbor.freshbrewed.science/freshbrewedprivate/example-nodejs"
        tag   = gitrefpretty()
        encoded_auth = var.harborcred
      }
    }
  }

  deploy {
    use "kubernetes" {
      image_secret = "myharborreg"
      probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
      // Sets up a load balancer to access released application
      load_balancer = true
      port          = 3000
    }
  }
}

variable "harborcred" {
  type    = string
  default = null
}