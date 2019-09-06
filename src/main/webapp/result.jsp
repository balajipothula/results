<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.Map"%>
<%@ page import="redis.clients.jedis.Jedis"%>
<%@ page import="redis.clients.jedis.exceptions.JedisConnectionException"%>

<!DOCTYPE html>
<html>
<head>
<title>Student Exam Results</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
body {
	font-family: 'Trebuchet MS', Arial, Helvetica, sans-serif;
}

input[type=text] {
	font-family: 'Trebuchet MS', Arial, Helvetica, sans-serif;
	width: 70%;
	padding: 12px 20px;
	margin: 8px 0;
	box-sizing: border-box;
	border: 3px solid #ccc;
	-webkit-transition: 0.5s;
	transition: 0.5s;
	outline: none;
	text-align: left;
	font-size: 12pt
}

input[type=text]:focus {
	border: 3px solid #555
}

input[type=submit] {
	background-color: #4CAF50;
	border: none;
	color: white;
	padding: 15px 32px;
	text-decoration: none;
	margin: 4px 2px;
	cursor: pointer;
	font-size: 12pt
}

#result {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	border-collapse: collapse;
	width: 80%;
	margin-left: auto;
	margin-right: auto
}

#result td {
	border: 1px solid #ddd;
	padding: 8px
}

#result tr:nth-child(even) {
	background-color: #FAFAFA
}

#result tr:nth-child(odd) {
	background-color: #E6E6E6
}

#result tr:hover {
	background-color: #ACFA58
}

#result th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: #4CAF50;
	color: white
}
</style>
<script type='text/javascript'>
	function validateHTNoForm() {
		var no = document.forms['ht']['no'].value;
		var noLength = 5;
		var lb = 10000;
		var ub = 99999;
		if (null == no || '' == no || isNaN(no) || no.length != noLength || lb > no
				|| no > ub) {
			alert('Please Enter Valid Hall Ticket Number');
			return false;
		}
	}
</script>
</head>
<body>
	<div align='center'>
		<form name='ht' onsubmit='return validateHTNoForm()' method='post'
			action='result.jsp'>
			<input type='text' name='no' required minlength='5' maxlength='5'
				placeholder='Enter Hall Ticket Number'> <input type='submit'
				value='Submit'>
		</form>
	</div>

	<%
	  final String host = "127.0.0.1";
	  final int port = 6379;
	  final int lb = 10000;
	  final int ub = 99999;
	  try {
	    String no = request.getParameter("no");
	    if (null != no && "" != no.trim()) {
	      int htno = Integer.parseInt(no);
	      if (lb <= htno && htno <= ub) {
	        Jedis redis = new Jedis(host, port);
	        int db = Integer.parseInt(no.substring(0, 1));
	        redis.select(db);
	        Map<String, String> resultMap = redis.hgetAll("ht:" + no);
	        redis.close();
	        String fname = resultMap.get("fname");
	        String lname = resultMap.get("lname");
	        int tel = Integer.parseInt(resultMap.get("tel"));
	        int hin = Integer.parseInt(resultMap.get("hin"));
	        int eng = Integer.parseInt(resultMap.get("eng"));
	        int mat = Integer.parseInt(resultMap.get("mat"));
	        int sci = Integer.parseInt(resultMap.get("sci"));
	        int soc = Integer.parseInt(resultMap.get("soc"));
	        int pam = 35;
	%>
	<table id='result'>
		<tr>
			<td align="right">Hall Ticket Number:</td>
			<td><%=no%></td>
		</tr>
		<tr>
			<td align="right">First Name:</td>
			<td><%=fname%></td>
		</tr>
		<tr>
			<td align="right">Last Name:</td>
			<td><%=lname%></td>
		</tr>
		<tr>
			<td align="right">Telugu:</td>
			<td><%=tel%></td>
		</tr>
		<tr>
			<td align="right">Hindi:</td>
			<td><%=hin%></td>
		</tr>
		<tr>
			<td align="right">English:</td>
			<td><%=eng%></td>
		</tr>
		<tr>
			<td align="right">Mathematics:</td>
			<td><%=mat%></td>
		</tr>
		<tr>
			<td align="right">General Science:</td>
			<td><%=sci%></td>
		</tr>
		<tr>
			<td align="right">Social Studies:</td>
			<td><%=soc%></td>
		</tr>
		<%
		  if (pam <= tel && pam <= hin && pam <= eng && pam <= mat && pam <= sci && pam <= soc) {
		          int tot = tel + hin + eng + mat + sci + soc;
		          float per = (float) tot / 600 * 100;
		%>
		<tr>
			<td align="right">Total</td>
			<td><%=tot%></td>
		</tr>
		<tr>
			<td align="right">Percentage:</td>
			<td><%=String.format("%.2f", per)%></td>
		</tr>
		<tr>
			<td align="right">Result:</td>
			<td>Passed</td>
		</tr>
		<%
		  } else {
		%>
		<tr>
			<td align="right">Result:</td>
			<td>Failed</td>
		</tr>
		<%
		  }
		      } else {
		        out.println("<h2 style='text-align:center;color:red;'>Enter Valid Hall Ticket Number</h2>");
		      }
		    }
		  } catch (NumberFormatException numberFormatException) {
		    out.println("<h2 style='text-align:center;color:red;'>Enter Valid Hall Ticket Number</h2>");
		  } catch (JedisConnectionException jedisConnectionException) {
		    out.println("<h4 style='text-align:center;color:red;'>Sorry unable to communicate with DB Server</h4>");
		    out.println("<h3 style='text-align:center;color:green;'>Inconvenience caused is deeply regretted</h3>");
		  }
		%>
	</table>
</body>
</html>
