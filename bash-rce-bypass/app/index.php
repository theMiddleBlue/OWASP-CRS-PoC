<?php

	if(isset($_GET["host"])) {
		system("host ".$_GET["host"]);
	} else {
		echo 'Usage: <a href="/?host=www.google.com">/?host=www.google.com</a>';
	}
