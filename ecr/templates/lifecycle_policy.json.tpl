{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expired older images after ${images_limit} images are reached",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${images_limit}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}

