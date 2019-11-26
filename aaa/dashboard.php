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

<!--	<img src="assets/naviGator.png" alt="UF" style="width:7%" display:inline-block>-->

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



                  <!--               <a class="nav-link active" href="dashboard.html" data-toggle="collapse" aria-expanded="false" data-target="#submenu-1" aria-controls="submenu-1" style="background-color:rgb(230,160,110);"><i class="fa fa-book"></i>READING <span class="badge badge-success">6</span></a>

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
						<div class="row">
							<div class="col-sm-9 scroll">
								<div class="card">
									<div class="card-body">
										<h5 class="card-title">Announcements</h5>
                    <ul>

                      <!-- If you want to add anything outside of the Annoucements Table Created
                            normal HTML Code can be inserted here to be above Annoucements. -->


                      <?php



                          $conn = mysqli_connect("localhost","root","","announcements");
                          if($conn -> connect_error){
                            die("Connection failed:". $conn-> connect_error);
                          }

                          $sql = "SELECT newannouncement from announcement_table";
                          $result = $conn-> query($sql);

                          if($result-> num_rows > 0){

                            while($row = $result-> fetch_assoc()){
                          //    echo "<tr><td>" . $row["newannouncement"] . "</td></tr>";

                        echo  $row["newannouncement"] ;
                            }

                            echo "</table>";
                          }


                          else{

                            echo "no announcements available yet";
                          }

                          $conn-> close();
                          ?>

                      </ul>

                      <!-- If you want to add anything outside of the Annoucements Table Created
                            normal HTML Code can be inserted here to be below Annoucements. -->
<!--
<li>Lab 3 (R3) starts Fri, 27 Sept, and ends Thur, 3 Oct.</li>
<li>Lab 4 (R0) starts Wed, 16 Oct, and ends Tues, 22 Oct.</li>
<li>HW 9 (R0) is due Thur, 17 Oct, before 8:59pm. Solutions for previous submitted HW are posted.</li>
<li>Exam 1 help sessions:</li>
<ul>
  <li>* Sun, 6 Oct, 4:00pm, WM 100</li>
<li>     + Will solve Exam 1P from spring 2019</li>
<li>  * Mon, 7 Oct, 6:15pm, WM 100</li>
<li> + Will solve Exam 1P from summer 2019</li>
</ul>
<li>Exam 1P (paper exam) is on Wed, Oct 9th and Exam 1L (lab exam) is on Mon, Oct 14th.</li>
<li>Exam 1P & 1L information.</li>
<li>Exam 1P (worth 27% of your course grade)</li>
<ul>
<li>Wed, Oct 9th, at 8:20pm.</li>
<li>Exam rooms (UF Map) are based on your last name:</li>
<ul>
<li>MAEA 303 (Last name: ??-??)</li>
<li>NEB 202 (Last name: ??-??)</li>
<li>NPB 1002 (Last name: ??-??)</li>
</ul>
<li>Please be prompt and bring your Gator-1 card.</li>
<li>More exam details and practice problems are available here.</li>
</ul>
<li>Exam 1L (worth 3% of your course grade)</li>
<ul>
<li>Mon, Oct 14th, at 8:20pm</li>

<li>Exam rooms (UF Map) are based on your last name:</li>
<ul>
<li>Unless told otherwise (by an email from Dr. Schwartz) WM 0100 (Last name: ??-??)</li>
<li>WEIL 0270 (Last name: ??-??)</li>
<li>PUGH 0170 (Last name: ??-??)</li>
</ul>
<li>Please be prompt and bring your Gator-1 card.</li>
<li>You will need your computer, tool box (with PLD board, DAD, all ICs, both breadboards, and wire kit).</li>
<li>Remove EVERYTHING from your breadboards (except for the PLD board and Vcc/Gnd wires).</li>
<li>You can NOT use any labs, homework, notes, etc. during this exam.</li>
<li>You must turn off your computer's WiFi and Bluetooth BEFORE the exam begins. (Exception for a Bluetooth mouse.)</li>
<li>More exam details and practice problems are available here.
</ul>
-->
										<p class="card-text"></p>
									</div>
								</div>
							</div>



              <div class="col-sm-3 scroll">
                 <div class="card">
                <div class="card-body p-0">
                   <a class="twitter-timeline" href="https://twitter.com/EEL3701?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor">3701 Tweets</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
                </div>
                <div class="card-footer text-center">
                   <a href="#" class="btn-primary-link">View Details</a>
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
