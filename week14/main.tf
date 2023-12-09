module "vpc" {
  source = "./modules/vpc"
  secret_id = var.secret_id
  secret_key = var.secret_key
}

module "cvm" {
  source = "./modules/cvm"
  secret_id = var.secret_id
  secret_key = var.secret_key
  password = var.password
  memory = 16
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  instance_name = "k8s"
}

resource "null_resource" "connect_ubuntu" {
  depends_on = [module.k3s]

  connection {
    host = module.cvm.public_ip
    type = "ssh"
    user = "ubuntu"
    password = var.password
  }

  triggers = {
    script_hash = filemd5("${path.module}/init.sh")
  }

  provisioner "file" {
    destination = "/tmp/init.sh"
    source = "${path.module}/init.sh"
  }

  provisioner "file" {
    destination = "/tmp/jenkins-values.yaml"
    content = templatefile(
      "${path.module}/yaml/jenkins-values.yaml.tpl",
      {
        "domain": "${var.domain}"
      }
    )
  }

  provisioner "file" {
    destination = "/tmp/jenkins-service-account.yaml"
    source = "${path.module}/yaml/jenkins-service-account.yaml"
  }

  provisioner "file" {
    destination = "/tmp/github-personal-token.yaml"
    content = templatefile(
      "${path.module}/yaml/github-personal-token.yaml.tpl",
      {
        "github_username" : "${var.github_username}"
        "github_personal_token" : "${var.github_personal_token}"
      }
    )
  }

  provisioner "file" {
    destination = "/tmp/github-pat-secret-text.yaml"
    content = templatefile(
      "${path.module}/yaml/github-pat-secret-text.yaml.tpl",
      {
        "github_personal_token" : "${var.github_personal_token}"
      }
    )
  }

  provisioner "file" {
    destination = "/tmp/argocd-dashboard-ingress.yaml"
    content = templatefile(
      "${path.module}/yaml/argocd-dashboard-ingress.yaml.tpl",
      {
        "domain": "${var.domain}"
      }
    )
  }

  provisioner "file" {
    destination = "/tmp/tf-provider.yaml"
    source = "${path.module}/yaml/tf-provider.yaml"
  }

  provisioner "file" {
    destination = "/tmp/ingress-values.yaml"
    source = "${path.module}/yaml/ingress-value.yaml"
  }

  provisioner "file" {
    destination = "/tmp/argocd-applicationset.yaml"
    source = "${path.module}/yaml/argocd-applicationset.yaml"
  }

  provisioner "file" {
    destination = "/tmp/ingress-value.yaml"
    source = "${path.module}/yaml/ingress-value.yaml.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "sh /tmp/init.sh",
    ]
  }
}

module "k3s" {
  source = "./modules/k3s"
  public_ip   = module.cvm.public_ip
  private_ip  = module.cvm.private_ip
  server_name = "k3s-hongkong-1"
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.k3s.kube_config
  filename = "${path.module}/config.yaml"
}