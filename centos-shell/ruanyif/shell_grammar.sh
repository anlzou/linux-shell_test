#echo
echo hello world

echo '	<html>
		<head>
			<title>Page Title</title>
		</head>
		<body>
			Page body.
		</body>
	</html>'

#-n do not output the trailing newline.
echo a;echo b

echo -n a;echo b

#-e enable interpretation of backslash escapes
echo "Hello\nWorld"
echo -e "Hello\nWorld" #or
echo -e 'Hello\nWorld'

# \
echo foo bar #like
echo foo \
bar

# ;
clear; ls -l

# && ||
#only 'cat file.txt' is true that exec 'ls -l file.txt'  
cat test_1.sh && ls -l test_1.sh

# ||
#...

#type tell you where command come from
type echo
type ls
type type

# type -a; see all def
type -a echo
# type -t; sell waht type
type -t bash
type -t if
