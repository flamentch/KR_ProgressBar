//%attributes = {}
#DECLARE($payload_ob : Object)->$result_ob : Object

If (False:C215)
	KR_ProgressBar
End if 

$result_ob:=New object:C1471

If (Count parameters:C259<1)
	$payload_ob:=New object:C1471
Else 
	$payload_ob:=$1
End if 

var $status_t : Text
$status_t:=$payload_ob.status

var $progBar_progressBarId_l : Integer
var $isButtonEnabled_b : Boolean
var $message_t : Text

Case of 
	: ($status_t="start")
		$progBar_progressBarId_l:=Progress New
		$result_ob.progressBarId:=$progBar_progressBarId_l
		
		Progress SET ON STOP METHOD($progBar_progressBarId_l; "KR_Progressbar_OnStopMethod")
		
		var $title_t : Text
		$title_t:=$payload_ob.title
		If ($title_t#"")
			Progress SET TITLE($progBar_progressBarId_l; $title_t)
		End if 
		
		$message_t:=$payload_ob.message
		If ($message_t#"")
			Progress SET MESSAGE($progBar_progressBarId_l; $message_t)
		End if 
		
		$isButtonEnabled_b:=$payload_ob.isButtonEnabled
		Progress SET BUTTON ENABLED($progBar_progressBarId_l; $isButtonEnabled_b)
		
	Else 
		
		$progBar_progressBarId_l:=$payload_ob.progressBarId
		If ($progBar_progressBarId_l#0)
			Case of 
				: ($status_t="buttonEnabled")
					$isButtonEnabled_b:=$payload_ob.isButtonEnabled
					Progress SET BUTTON ENABLED($progBar_progressBarId_l; $isButtonEnabled_b)
					
				: ($status_t="checkStopped")
					$result_ob.isStopped:=Progress Stopped($progBar_progressBarId_l)
					
				: ($status_t="progress")
					var $ratio_r : Real
					$ratio_r:=$payload_ob.ratio
					$message_t:=$payload_ob.message
					Progress SET PROGRESS($progBar_progressBarId_l; $ratio_r; $message_t)
					
				: ($status_t="message")
					$message_t:=$payload_ob.message
					If ($message_t#"")
						Progress SET MESSAGE($progBar_progressBarId_l; $message_t)
					End if 
					
				: ($status_t="quit")
					Progress QUIT($progBar_progressBarId_l)
					
			End case 
		End if 
End case 
