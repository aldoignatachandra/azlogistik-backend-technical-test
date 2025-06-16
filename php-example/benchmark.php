<?php
$loops = 100000000; // 10 billion iterations
echo 'Testing dirname(__FILE__)' . PHP_EOL;
echo '<br>';

$start = time();
$dir = '';
for ($i = 0; $i < $loops; $i++) {
    $dir = dirname(__FILE__);
}
echo 'dirname(__FILE__) took ' . (time() - $start) . 's' . PHP_EOL;

echo '<br>';

$start = time();
$dir = '';
for ($i = 0; $i < $loops; $i++) {
    $dir = __DIR__;
}
echo '__DIR__ took ' . (time() - $start) . 's' . PHP_EOL;
