<!DOCTYPE HTML>
<html>

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



<body>






  					<div class="col scroll" style="background-color:rgb(3,81,153)">
  						<div class="card">



  					<form method = "post" action = "database.php">
  					<table align="center">

  						<tr>
  							<td>  Announcement Number</td>
  							<td><input type ="text" name="AnnoucementID" class="form-control"/></td> 	<td><input type="submit" style="background-color:rgb(183,89,23)" name="update" value="Update" class="btn btn-success btn-lg"/></td>	<td><input type="submit" style="background-color:rgb(183,89,23)" name="delete" value="Delete" class="btn btn-success btn-lg"/></td>
            	</tr>
  						<tr>
  						<!--	<td><input type="submit" name="update" value="Update" class="btn btn-success btn-lg"/></td>	<td><input type="submit" name="delete" value="Delete" class="btn btn-success btn-lg"/></td>-->
  						</tr>
  					</table>
  					</form>
  					</div>
  					</div>



<!--<div class="dashboard-wrapper">-->
		<div class="dashboard-ecommerce">
			<div class="container-fluid dashboard-content ">
				<div class="row">

					<div class="col scroll style="background-color:rgb(3,81,153)">
						 <div class="card">

					<?php
					//echo "<div class="col-sm-6 scroll">";
					$conn = mysqli_connect("localhost","root","","announcements");

					//print out entire base table
					$sql = "SELECT * from base_table";
					$result = $conn-> query($sql);

					if($result-> num_rows > 0){

					echo "<table = border = '10' cellpadding='20' width= '100%'><tr><th>Annoucement to be Posted</th><th>Annoucement Number</th></tr>";
					  while($row = $result-> fetch_assoc()){
					//    echo "<tr><td>" . $row["newannouncement"] . "</td></tr>";
					echo "<tr><td><ul>";
					echo  $row["baseannouncement"] ;
					echo "</ul></td><td><ul>";
					echo $row["id"];
					echo "</ul></td></tr>";
					  }

					  echo "</table>";
					}


					else{

					  echo "no announcements available yet";
					}

					//echo "</div>";
					?>
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
