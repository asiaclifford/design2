<!doctype html>
<html lang="en">

<head>

<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="assets/vendor/bootstrap/css/bootstrap.min.css">
    <link href="assets/vendor/fonts/circular-std/style.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/libs/css/style.css">
    <link rel="stylesheet" href="assets/vendor/fonts/fontawesome/css/fontawesome-all.css">
    <link rel="stylesheet" href="assets/vendor/fonts/material-design-iconic-font/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="assets/vendor/fonts/flag-icon-css/flag-icon.min.css">
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
    <title>Schwartz Website Template</title>
</head>

<?php

  function file_updated($file)
  {
    $filename = $file;
    if (file_exists($filename))
    {
      echo "Updated: " . date ("F d", filemtime($filename));
    }
  }
  ?>

<body style="background-color:rgb(3,81,153);">
    <!-- ============================================================== -->
    <!-- main wrapper -->
    <!-- ============================================================== -->
    <div class="dashboard-main-wrapper">
        <!-- ============================================================== -->
        <!-- navbar -->
        <!-- ============================================================== -->
        <div class="dashboard-header">
            <nav class="navbar navbar-expand-lg bg-white fixed-top">
              	<img src="assets/naviGator.png" alt="UF" style="width:7%" display:inline-block>
                <a class="navbar-brand" href="dashboard.html" style="color:rgb(3,81,153);">EEL3701C: Digital Logic and Computer Systems</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse " id="navbarSupportedContent">
                    <ul class="navbar-nav ml-auto navbar-right-top">

                    </ul>
                </div>
            </nav>
        </div>
        <!-- ============================================================== -->
        <!-- end navbar -->
        <!-- ============================================================== -->
        <!-- ============================================================== -->
        <!-- left sidebar -->
        <!-- ============================================================== -->
        <div class="nav-left-sidebar sidebar-dark" style="background-color:rgb(183,89,23);">
            <div class="menu-list">
                <nav class="navbar navbar-expand-lg navbar-light">
                  <!--  <a class="d-xl-none d-lg-none" href="#">Dashboard</a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button> -->
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav flex-column">
                            <li class="nav-divider">
                                Menu
                            </li>
                            <li class="nav-item ">
                                <a class="nav-link active" href="dashboard.php" style="background-color:rgb(189,117,66);"><i class="fa fa-home"></i>HOME <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="calendar.php" style="background-color:rgb(189,117,66);"><i class="fa fa-calendar"></i>OFFICE HOURS <span class="badge badge-success">6</span></a>

                                <a class="nav-link active" href="syllabus.php" style="background-color:rgb(189,117,66);"><i class="fa fa-map" aria-hidden="true"></i>SYLLABUS <br>
                                  <?php
                  									file_updated("assets/syl_f19.pdf");
                  								?>

                                  <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="labs.php" style="background-color:rgb(189,117,66);"><i class="fa fa-users"></i>LABS <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="hw.php" style="background-color:rgb(189,117,66);"><i class="fa fa-file"></i>HW <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="exams.php" style="background-color:rgb(189,117,66);"><i class="fa fa-pencil" aria-hidden="true"></i>EXAMS<span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="grades.php" style="background-color:rgb(189,117,66);"><i class="fa fa-percent" ></i>GRADES<span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="lectures.php" style="background-color:rgb(189,117,66);"><i class="fa fa-fw fa-user-circle" ></i>LECTURES<span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://www.youtube.com/channel/UCSRf3fNNpRG4YJc27TnYzEg" style="background-color:rgb(189,117,66);"><i class="fa fa-film"></i>VIDEOS <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="reading.php" style="background-color:rgb(189,117,66);"><i class="fa fa-book"></i>READING <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="/aaa/assets/3701_website/pinouts/pinouts.html" style="background-color:rgb(189,117,66);">PINOUTS <span class="badge badge-success">6</span></a>


                                <a class="nav-link active" href="http://www.ufl.edu/" style="background-color:rgb(189,117,66);">UF <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://www.ece.ufl.edu/" style="background-color:rgb(189,117,66);">ECE Department <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://cpe.eng.ufl.edu/" style="background-color:rgb(189,117,66);">CpE Program <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://www.cise.ufl.edu/" style="background-color:rgb(189,117,66);">CISE Department <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://mae.ufl.edu/" style="background-color:rgb(189,117,66);">MAE Department <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://www.eng.ufl.edu/" style="background-color:rgb(189,117,66);">The Herbert Wertheim College of Engineering <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://dso.ufl.edu/judicial/" style="background-color:rgb(189,117,66);">Academic Honesty <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="https://mil.ufl.edu/3701/admin/Incomplete_Policy.htm" style="background-color:rgb(189,117,66);">Incomplete policy <span class="badge badge-success">6</span></a>
                                <a class="nav-link active" href="http://www.anonymousfeedback.net/send-anonymous-email/embed/?to_name=Dr.%20Schwartz%20for%20UF's%20EEL3701&to_email=ems@ufl.edu&use_from=1" style="background-color:rgb(189,117,66);">Anonymous Email <span class="badge badge-success">6</span></a>
                  <!--               <a class="nav-link active" href="dashboard.html" data-toggle="collapse" aria-expanded="false" data-target="#submenu-1" aria-controls="submenu-1" style="background-color:rgb(230,160,110);"><i class="fa fa-book"></i> READING <span class="badge badge-success">6</span></a>

				<div id="submenu-1" class="collapse submenu" style="">
                                   <ul class="nav flex-column">
                                        <li class="nav-item">
                                            <a class="nav-link" href="trends.html">Trends Search</a>
                                        </li>
					                              <li class="nav-item">
                                            <a class="nav-link" href="keyword.html">Keyword Search</a>
                                        </li>
                                    </ul>
                                </div> -->
                            </li>
                        </ul>
                    </div>
                </nav>
            </div>
        </div>
        <!-- ============================================================== -->
        <!-- end left sidebar -->
        <!-- ============================================================== -->
        <!-- ============================================================== -->
        <!-- wrapper  -->
        <!-- ============================================================== -->
        <div class="dashboard-wrapper">
            <div class="dashboard-ecommerce">
                <div class="container-fluid dashboard-content ">

                            <div class="col-xl-30 col-lg-12 col-md-6 col-sm-12 col-12">
				<div class="card">
                                    <h5 class="card-header">Homework</h5>
                                    <div class="card-body p-0">
          <a class="nav-link active" href="https://ufl.instructure.com/"> Due: Aug. 23rd, Friday &nbsp &nbsp &nbsp &nbsp Homework 0 - On Canvas </a>
					<a class="nav-link active" href="assets/3701_website/hw/hw1.pdf"> Due: Sept. 8th, Sunday &nbsp &nbsp &nbsp &nbsp Homework 1 <b><?php
						$x = file_updated("assets/3701_website/hw/hw1.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw2.pdf"> Due: Sept. 6th, Friday &nbsp &nbsp &nbsp &nbsp Homework 2 <b><?php
						$x = file_updated("assets/3701_website/hw/hw2.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw3.pdf"> Due: Sept. 13th, Friday &nbsp &nbsp &nbsp &nbsp Homework 3 <b><?php
						$x = file_updated("assets/3701_website/hw/hw3.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw4.pdf"> Due: Sept. 22nd, Sunday &nbsp &nbsp &nbsp &nbsp Homework 4 <b><?php
						$x = file_updated("assets/3701_website/hw/hw4.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw5.pdf"> Due: Sept. 23rd, Monday &nbsp &nbsp &nbsp &nbsp Homework 5 <b><?php
						$x = file_updated("assets/3701_website/hw/hw5.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw6.pdf"> Due: Oct. 1st, Tuesday &nbsp &nbsp &nbsp &nbsp Homework 6 <b><?php
						$x = file_updated("assets/3701_website/hw/hw6.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw7.pdf"> Due: Sept. 26th, Thursday &nbsp &nbsp &nbsp &nbsp Homework 7 <b><?php
						$x = file_updated("assets/3701_website/hw/hw7.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
          <a class="nav-link active" href="assets/3701_website/hw/hw_MUX.pdf"> Due: NEVER &nbsp &nbsp &nbsp &nbsp Homework MUX <b><?php
						$x = file_updated("assets/3701_website/hw/hw_MUX.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
          <a class="nav-link active" href="assets/3701_website/hw/hw8.pdf"> Due: Oct. 3rd, Thursday &nbsp &nbsp &nbsp &nbsp Homework 8 <b><?php
						$x = file_updated("assets/3701_website/hw/hw8.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw9.pdf"> Due: Oct. 17th, Thursday &nbsp &nbsp &nbsp &nbsp Homework 9 <b><?php
						$x = file_updated("assets/3701_website/hw/hw9.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw10.pdf"> Due: Oct. 26th, Saturday &nbsp &nbsp &nbsp &nbsp Homework 10 <b><?php
						$x = file_updated("assets/3701_website/hw/hw10.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw11.pdf"> Due: Nov. 18th, Monday &nbsp &nbsp &nbsp &nbsp Homework 11 <b><?php
						$x = file_updated("assets/3701_website/hw/hw11.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/hw/hw12.pdf"> Due: NEVER &nbsp &nbsp &nbsp &nbsp Homework 12 <b><?php
						$x = file_updated("assets/3701_website/hw/hw12.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>
			    </div>


                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- ============================================================== -->
        <!-- end wrapper  -->
        <!-- ============================================================== -->
    </div>
    <!-- ============================================================== -->
    <!-- end main wrapper  -->
    <!-- ============================================================== -->
    <!-- Optional JavaScript -->
    <!-- jquery 3.3.1 -->
    <script src="assets/vendor/jquery/jquery-3.3.1.min.js"></script>
    <!-- bootstap bundle js -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.js"></script>
    <!-- slimscroll js -->
    <script src="assets/vendor/slimscroll/jquery.slimscroll.js"></script>
    <!-- main js -->
    <script src="assets/libs/js/main-js.js"></script>
    <!-- sparkline js -->
    <script src="assets/vendor/charts/sparkline/jquery.sparkline.js"></script>
    <!-- morris js -->
    <script src="assets/vendor/charts/morris-bundle/raphael.min.js"></script>
    <script src="assets/vendor/charts/morris-bundle/morris.js"></script>

</body>

</html>
