plan(1);

% System shell tests
if getenv('WINDIR') != ''
    % Windows tests
    !cmd /c echo ok 3
else
    % Non-windows tests
    !echo "ok 3"
end
