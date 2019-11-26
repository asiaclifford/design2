<?php
/*
function print_annouce($id_num)
{
  $conn = mysqli_connect("localhost","root","","announcements");
  $sql = "SELECT baseannouncement from base_table WHERE id = $id_num";
  $result = $conn-> query($sql);
  if($result-> num_rows > 0){

    while($row = $result-> fetch_assoc()){

  echo  $row["baseannouncement"] ;
    }

    echo "</table>";
  }


  else{

    echo "no announcements available yet";
  }

  if($conn -> connect_error){
    die("Connection failed:". $conn-> connect_error);
  }

  $conn-> close();
}
*/










	$dbconnect = mysqli_connect('localhost', 'root', '', 'announcements');

  if(mysqli_connect_errno($dbconnect)){

    echo "Failed to connect\n";
  }

  else{
    echo "Connection successful\n";
  }

function input_announce($id_num)
{
	$dbconnect = mysqli_connect('localhost', 'root', '', 'announcements');
  $abaseannounce = mysqli_query($dbconnect,"INSERT into announcement_table SELECT * FROM base_table WHERE id = $id_num");;
  if($abaseannounce){
  echo "Inserted";
  }
  else{
  echo "Error";
  }
}

function delete_announce($id_num)
{
	$dbconnect = mysqli_connect('localhost', 'root', '', 'announcements');
	$abaseannounce = mysqli_query($dbconnect, "DELETE FROM announcement_table WHERE id = $id_num");
  if($abaseannounce){
  echo "Deleted";
  }
  else{
  echo "Error";
  }

}

if(isset($_POST['update']))
{
	$inputval = $_POST['AnnoucementID'];
	input_announce($inputval);

}
if(isset($_POST['delete']))
{
	$inputval = $_POST['AnnoucementID'];
	delete_announce($inputval);
}

?>
