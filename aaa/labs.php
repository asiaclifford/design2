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
                                    <h3 class="card-header">Important Reminders</h3>
                                    <div class="card-body p-0">
					<ul>
						<li> Canvas submissions are due 15 minutes <b><u>BEFORE</u></b> the start of your lab. </li>
						<li> Complete the required material before coming to lab or you may be denied entry. </li>
						<li> Your labs are precisely 1 hr and 55 min. You will be given <b>NO</b> extra time. </li>
						<li> You must show up within the first <b>10 minutes</b> of your lab starting to be eligible to take the lab quiz. </li>
						<li> Lab quizzes may start when lab begins. If you miss a quiz, you get a zero on that quiz. </li>
						<li> You must show up within the first <b>20 minutes</b> of your lab starting time or you will not be admitted. </li>
						<li> Labs meet in NEB 248. </li>
					</ul>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">General Lab Documents</h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab0/lab_rules_policies.pdf"> Lab Rules & Policies <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/lab_rules_policies.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/Lab_Submission_Template.pdf"> Lab Submission Template <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/Lab_Submission_Template.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/3701_Parts_List_27Apr19.pdf"> Parts List <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/3701_Parts_List_27Apr19.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<h4>&nbsp &nbsp &nbsp &nbsp <b><u>MAX 10 Documentaiton</u></b></h4>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/m10_overview.pdf"> MAX 10 Overview </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/m10_architecture.pdf"> MAX 10 Architecture </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/lab_rules_policies.pdf"> Lab Rules & Policies </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/ug_ram_rom_Embedded_Memory.pdf"> MAX 10 User Embedded RAM/ROM (1PORT/2PORT) Memory </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/ug_m10_ufm_User_Flash_Memory.pdf"> MAX 10 User Flash Memory </a>
					<h4>&nbsp &nbsp &nbsp &nbsp <b><u>OOTB Documentation</u></b></h4>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/OOTB_CPLD_Programmer.pdf"> Out of the Box CPLD Programmer </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/MXDB_Manual.pdf"> MAX 10 Development Board Manual </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/MXDB_SCH.pdf"> MAX 10 Schematic <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/MXDB_SCH.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 0 Starts: Aug. 26th, Monday</h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab0/lab0_f19_intro_and_construction.pdf"> <b> Lab 0 Document </b> <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/lab0_f19_intro_and_construction.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/chapter3_MIT_6270_Manual.pdf"> Electronic Assembly Handout (Chapter 3, MIT 6270 Manual) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/quartus18.1_installation.pdf"> Quartus 18.1 Installation Instructions <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/quartus18.1_installation.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/MXDB_Assembly_Guide.pdf"> OOTB Assembly Guide <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/MXDB_Assembly_Guide.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/MXDB_Manual.pdf"> MAX 10 Development Board Manual <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/MXDB_Manual.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/MXDB_SCH.pdf"> MAX 10 Schematic <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/MXDB_SCH.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab0/hardware_get_started.pdf"> Hardware: Getting Started <b><?php
						$x = file_updated("assets/3701_website/labs/lab0/hardware_get_started.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 1 Starts: Sept. 9th, Monday </h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab1/lab1_f19_logic_design.pdf"> <b> Lab 1 Document <?php
						$x = file_updated("assets/3701_website/labs/lab1/lab1_f19_logic_design.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab1/quartus_18.1_tutorial.pdf"> Quartus Tutorial <b><?php
						$x = file_updated("assets/3701_website/labs/lab1/quartus_18.1_tutorial.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab1/Quartus_Display_Issues.pdf"> Quartus Display Issues (For High Resolution Monitors) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab1/OOTB_CPLD_Programmer.pdf"> OOTB CPLD Programmer Instructions </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab1/hardware_get_started.pdf"> Hardware: Getting Started <b><?php
						$x = file_updated("assets/3701_website/labs/lab1/hardware_get_started.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab1/pinouts.pdf"> Pinout of Common Parts </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab1/protoboard_for_layouts.pdf"> Protoboard Layout </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab1/student_corres.txt"> Student Correspondence about Quartus and Active-Low Signals </a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 2 Starts: Sept. 16th, Monday</h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab2/lab2_f19_MSI.pdf"> <b> Lab 2 Document </b> <b><?php
						$x = file_updated("assets/3701_website/labs/lab2/lab2_f19_MSI.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab2/quartus_18.1_tutorial.pdf"> Quartus Tutorial <b><?php
						$x = file_updated("assets/3701_website/labs/lab2/quartus_18.1_tutorial.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab2/hex_to_7seg.bdf"> hex_to_7seg.bdf </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab2/OOTB_7-seg.pdf"> Documentation for 7-Segment Displays on MAX 10 PCB <b><?php
						$x = file_updated("assets/3701_website/labs/lab2/OOTB_7-seg.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab2/sevenSegmentDatasheet.pdf"> 7-Segment LED Data Sheet </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab2/74HC153_national.pdf"> 74HC153 Dual 4-Input Multiplexer (National Specification) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab2/74HC153_philips.pdf"> 74HC153 Dual 4-Input Multiplexer (Philips Specification) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab2/wire_bus.pdf"> Using Wires and Buses in Quartus BDF Files <b><?php
						$x = file_updated("assets/3701_website/labs/lab2/wire_bus.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 3 Starts: Sept. 27th, Friday </h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab3/lab3_f19_Debouncing_Counter.pdf"> <b> Lab 3 Document </b> <b><?php
						$x = file_updated("assets/3701_website/labs/lab3/lab3_f19_Debouncing_Counter.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 4 Starts: Oct. 21st, Monday </h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab4/lab4_f19_ALU_CPU.pdf"> <b> Lab 4 Document </b> <b><?php
						$x = file_updated("assets/3701_website/labs/lab4/lab4_f19_ALU_CPU.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab4/74HC283_national.pdf"> 74HC283 4-Bit Binary Adder with Fast Carry (National Specification) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab4/74HC283_philips.pdf"> 74HC283 4-Bit Binary Adder with Fast Carry (Philips Specification) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab4/PLD_PCB_Debug.pdf"> Debugging your PLD PCB <b><?php
						$x = file_updated("assets/3701_website/labs/lab4/PLD_PCB_Debug.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 5 Starts: October 28th, Monday</h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab5/lab5_f19_traffic_controller.pdf"> <b> Lab 5 Document </b> <b><?php
						$x = file_updated("assets/3701_website/labs/lab5/lab5_f19_traffic_controller.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab5/Component_Creation.pdf"> Creating Graphical Components  </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab5/CompCreation.qar"> Archive File for Documents </a>
                                    </div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 6 Starts: November 4th, Monday</h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab6/lab6_f19_cpu_design.pdf"> <b> Lab 6 Document </b> <b><?php
						$x = file_updated("assets/3701_website/labs/lab6/lab6_f19_cpu_design.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/rom_8k.mif"> rom_8k.mif </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/rom_creation.pdf"> ROM Creation Tutorial for Quartus Prime Lite Edition 18.1  <b><?php
						$x = file_updated("assets/3701_website/labs/lab6/rom_creation.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/rom_1kx8.qar"> Quartus Archive for ROM Creation Tutorial </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/mif_creation.pdf"> Quartus Memory Initialization File (MIF)  <b><?php
						$x = file_updated("assets/3701_website/labs/lab6/mif_creation.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/bus.pdf"> Using Busses and "Wires" in Quartus Schematic Entry (bdf) Files  <b><?php
						$x = file_updated("assets/3701_website/labs/lab6/bus.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/Bus.qar"> Quartus archive for "Using Busses..." Tutorial </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/74HC161-163_motorola.pdf"> Specifications for the 74HC161 and 74HC163 4-bit Counters. (338k) Motorola </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab5/74HC161_philips.pdf"> Specifications for the 74HC161 4-Bit Counter. (82KB) Philips </a>
					<h4>&nbsp &nbsp &nbsp &nbsp <b><u>VHDL ROM Alternative:</u></b></h4>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/VHDL_ROM.pdf"> Instructions for using the VHDL ROM alternative </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/BOARD_ROM.qar"> Quartus archive file, Board_ROM.qar </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/ROM_contents.xlsx"> Excel spreadsheet, ROM_contents.xlsx </a>
									</div>
                                    <div class="card-footer text-center">
                                    </div>
                                </div>

				<div class="card">
                                    <h3 class="card-header">Lab 7 Starts: Nov. 13th, Wednesday</h3>
                                    <div class="card-body p-0">
					<a class="nav-link active" href="assets/3701_website/labs/lab7/lab7_f19_gcpu.pdf"> <b> Lab 7 Document </b> <b><?php
						$x = file_updated("assets/3701_website/labs/lab7/lab7_f19_gcpu.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
                    <a class="nav-link active" href="assets/3701_website/labs/lab7/Assembly_List.docx"> Assembly List File (MS-Word) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab7/Assembly_List.xlsx"> Assembly List File (Excel) </a>
					<a class="nav-link active" href="assets/3701_website/labs/lab7/rom_creation.pdf"> ROM Creation Tutorial for Quartus Prime Lite Edition 18.1  (in one pdf) <b><?php
						$x = file_updated("assets/3701_website/labs/lab7/rom_creation.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab7/G-CPU_Complete_Documentation_22Apr19.pdf"> Documentation and Design Files  <b><?php
						$x = file_updated("assets/3701_website/labs/lab7/G-CPU_Complete_Documentation_22Apr19.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/lab6_f19_cpu_design.pdf"> Documentation and Simulation Files  <b><?php
						$x = file_updated("assets/3701_website/labs/lab6/lab6_f19_cpu_design.pdf");
						echo "&nbsp &nbsp &nbsp &nbsp" . $x
					?></b></a>
					<a class="nav-link active" href="assets/3701_website/labs/lab6/gcpu-s19.qar"> Archived G-CPU Quartus files  <b><?php
						$x = file_updated("assets/3701_website/labs/lab6/gcpu-s19.qar");
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
