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
            <div class="container-fluid dashboard-content">
      <div class="row">
        <div class="col">
          <div class="card ">
                      <ul class="nav nav-tabs">
                <li class="nav-item">
                  <a href="#OfficeHours" class="nav-link active" role="tab" data-toggle="tab">PI Office Hours</a>
                </li>

                <li class="nav-item">
                  <a href="#LabHours" class="nav-link" role="tab" data-toggle="tab">Lab Hours</a>
                </li>

                <li class="nav-item">
                  <a href="#CanvasOnlineHours" class="nav-link" role="tab" data-toggle="tab">Canvas Online Hours</a>
                </li>
            <li class="nav-item">
                  <a href="#PIContact" class="nav-link" role="tab" data-toggle="tab">PI Contact Information</a>
                </li>
              </ul>

              <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="OfficeHours">
              <iframe src="https://outlook.office365.com/owa/calendar/c25e3c6bf57e4a899b166ac54c94811d@ufl.edu/1e38ff4951454ff0bb6e396f988e31a414401959391612376799/calendar.html" style="border:solid 1px #777" width="100%" height="800" frameborder="0"></iframe>
            </div>
                <div role="tabpanel" class="tab-pane" id="LabHours">
              <iframe src="https://outlook.office365.com/owa/calendar/c25e3c6bf57e4a899b166ac54c94811d@ufl.edu/a65ca89a24ea4eddaaf9e44890e4dc0d5546715993755923538/calendar.html" style="border:solid 1px #777" width="100%" height="800" frameborder="0"></iframe>
            </div>
                <div role="tabpanel" class="tab-pane" id="CanvasOnlineHours">
              <iframe src="https://outlook.office365.com/owa/calendar/c25e3c6bf57e4a899b166ac54c94811d@ufl.edu/c35286356c984ba3959297f8c7f02422674416111522081990/calendar.html" style="border:solid 1px #777" width="100%" height="800" frameborder="0"></iframe>
            </div>
            <div role="tabpanel" class="tab-pane" id="PIContact">
              <H3>&nbsp &nbsp &nbsp &nbsp PI Contact Information</H3>
              <center>
              <table cellpadding = "5">
                <tr>
                  <td> <a HREF="assets/3701_website/pix/GregoryDeCanio.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/GregoryDeCanio.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Gregory DeCanio"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Gregory DeCanio, PI <br>
                      e-mail: <A HREF="mailto:gdecanio@ufl.edu">
                      <FONT COLOR="green">gdecanio@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/AngelaCook.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/AngelaCook.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Angela Cook"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Angela Cook, PI <br>
                      e-mail: <A HREF="mailto:angelaccook@ufl.edu">
                      <FONT COLOR="green">angelaccook@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/KevinLovell.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/KevinLovell.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Kevin Lovell"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Kevin Lovell, PI <br>
                      e-mail: <A HREF="mailto:kevin.lovell96@ufl.edu">
                      <FONT COLOR="green">kevin.lovell96@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/BlakeShaffer.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/BlakeShaffer.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Blake Shaffer"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Kevin Lovell, PI <br>
                      e-mail: <A HREF="mailto:thomasshaffer@ufl.edu">
                      <FONT COLOR="green">thomasshafer@ufl.edu</FONT></A>
                  </td>
                </tr>
                  <td> <a HREF="assets/3701_website/pix/LysnyWoodahl.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/LysnyWoodahl.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Lysny Woodahl"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Lysny Woodahl, PI <br>
                      e-mail: <A HREF="mailto:lwoodahl@ufl.edu">
                      <FONT COLOR="green">lwoodahl@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/AlexanderShuping.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/AlexanderShuping.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Alexander Shuping"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Alexander Shuping, PI <br>
                      e-mail: <A HREF="mailto:alexandershuping@ufl.edu">
                      <FONT COLOR="green">alexandershuping@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/JaxonBrown.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/JaxonBrown.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Jaxon Brown"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Jaxon Brown, PI <br>
                      e-mail: <A HREF="mailto:JaxonBrown@ufl.edu">
                      <FONT COLOR="green">JaxonBrown@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/FrankMitchell.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/FrankMitchell.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Frank Mitchell"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Frank Mitchell, PI <br>
                      e-mail: <A HREF="mailto:jake2849@ufl.edu">
                      <FONT COLOR="green">jake2849@ufl.edu</FONT></A>
                  </td>
                </tr>
                <tr>
                  <td> <a HREF="assets/3701_website/pix/MarquezJones.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/MarquezJones.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Marquez Jones"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Marquez Jones, PI <br>
                      e-mail: <A HREF="mailto:marquezjones@ufl.edu">
                      <FONT COLOR="green">marquezjones@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/JonLegaspi.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/JonLegaspi.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Jon Legaspi"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Jon Legaspi, PI <br>
                      e-mail: <A HREF="mailto:jon.legaspi@ufl.edu">
                      <FONT COLOR="green">jon.legaspi@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/TomaszWiercioch.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/TomaszWiercioch.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Tomasz Wiercioch"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Tomasz Wiercioch, PI <br>
                      e-mail: <A HREF="mailto:twiercioch@ufl.edu">
                      <FONT COLOR="green">twiercioch@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/DamienBobrek.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/DamienBobrek.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Damien Bobrek"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Damien Bobrek, PI<br>
                      e-mail: <A HREF="mailto:dbobrek@ufl.edu">
                      <FONT COLOR="green">dbobrek@ufl.edu</FONT></A>
                  </td>
                </tr>
                <tr>
                <td> <a HREF="assets/3701_website/pix/SpencerComora.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/SpencerComora.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Spencer Comora"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Spencer Comora, PI<br>
                      e-mail: <A HREF="mailto:scomora@ufl.edu">
                      <FONT COLOR="green">scomora@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/MacPierre.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/MacPierre.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Mac Pierre"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Mac Pierre, PI<br>
                      e-mail: <A HREF="mailto:mac.pierre@ufl.edu">
                      <FONT COLOR="green">mac.pierre@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/BeichenSu.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/BeichenSu.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Beichen Su"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Oliver (Beichen) Su, PI <br>
                      e-mail: <A HREF="mailto:su1998@ufl.edu">
                      <FONT COLOR="green">su1998@ufl.edu</FONT></A>
                  </td>
                  <td> <a HREF="assets/3701_website/pix/CamiloChen.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/CamiloChen.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="Camilo Chen"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Camilo Chen, PI<br>
                      e-mail: <A HREF="mailto:camilo.chen@ufl.edu">
                      <FONT COLOR="green">camilo.chen@ufl.edu</FONT></A>
                  </td>
                </tr>
                <tr>
                  <td> <a HREF="assets/3701_website/pix/DanielFaltemier.jpg" target="_top">
                    <img SRC="assets/3701_website/pix/DanielFaltemier.jpg" WIDTH=80
                      Border="0" ALIGN="right"
                      Align="top" ALT="DanielFaltemier"></a>
                  </td>
                  <td align="left" COLSPAN=2>
                      Daniel Faltemier, PI<br>
                      e-mail: <A HREF="mailto:dfaltemier@ufl.edu">
                      <FONT COLOR="green">dfaltemier@ufl.edu</FONT></A>
                  </td>

                </tr>

              <table>
              </center>
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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <script src="assets/vendor/jquery/jquery-3.3.1.min.js"></script>
    <!-- bootstap bundle js -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.js"></script>
	<script src="https://cdn.rawgit.com/twbs/bootstrap/v4-dev/dist/js/bootstrap.js"></script>
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
