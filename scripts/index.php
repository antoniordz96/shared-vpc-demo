<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Antonio Rodriguez">
    <meta name="generator" content="Hugo 0.84.0">
    <title>GCP Automation</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <style>
        .bd-placeholder-img {
            font-size: 1.125rem;
            text-anchor: middle;
            -webkit-user-select: none;
            -moz-user-select: none;
            user-select: none;
        }

        @media (min-width: 768px) {
            .bd-placeholder-img-lg {
                font-size: 3.5rem;
            }
        }
    </style>


</head>

<body>

    <header>
        <div class="collapse bg-dark" id="navbarHeader">
            <div class="container">
                <div class="row">
                    <div class="col-sm-8 col-md-7 py-4">
                        <h4 class="text-white">GCP and Terraform IAC</h4>
                        <p class="text-muted">Welcome to GCP!</p>
                    </div>
                    <div class="col-sm-4 offset-md-1 py-4">
                        <h4 class="text-white">Resources</h4>
                        <ul class="list-unstyled">
                            <li><a href="https://github.com/antoniordz96/shared-vpc-demo" class="text-white">GitHub Source Code</a></li>
                            <li><a href="https://www.linkedin.com" class="text-white">LinkedIn</a></li>
                            <li><a href="https://console.cloud.google.com" class="text-white">Google Cloud Console</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="navbar navbar-dark bg-dark shadow-sm">
            <div class="container">
                <a href="#" class="navbar-brand d-flex align-items-center">
                    <strong>GCP and Terraform Automation</strong>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarHeader" aria-controls="navbarHeader" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>
        </div>
    </header>

    <main>

        <section class="py-5 text-center container">
            <div class="row py-lg-5">
                <div class="col-lg-6 col-md-8 mx-auto">
                    <h1 class="fw-light">GCP and Terraform Automation</h1>
                    <img src="https://cdn.iconscout.com/icon/free/png-256/google-cloud-2038785-1721675.png">
                    <p class="lead text-muted">You successfully have deployed your application on GCP via terraform!</p>
                    <p class="lead text-muted">
                        Server Address: <?php echo $_SERVER['SERVER_ADDR']; ?>
                    </p>
                    <p class="lead text-muted">
                        HostName: <?php echo gethostname(); ?>
                    </p>
                </div>
            </div>
        </section>



    </main>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>


</body></html>
