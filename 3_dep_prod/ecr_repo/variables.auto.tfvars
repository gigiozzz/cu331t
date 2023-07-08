tags = {
  "Environment" = "Test"
}

ecr_names = ["cuapp", "curp"]

image_mutability = "MUTABLE" # mutable in test env/repo but should be immutable in prod env/repo