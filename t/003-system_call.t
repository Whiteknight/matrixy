disp("1..3")

% System shell tests
if getenv('WINDIR') != ''
    % Windows tests
    system("cmd /c echo ok 1");
    system(["cmd /c echo ok 2"]);
    !cmd /c echo ok 3
else
    % Non-windows tests
    system("echo ok 1");
    system(["echo ok 2"]);
    !echo "ok 3"
end