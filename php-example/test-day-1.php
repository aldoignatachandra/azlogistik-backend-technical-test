<?php

// always enable strict mode
declare(strict_types=1);

// single-line comment
/* multi-line comment */

echo "Hello, world";

echo "<br><br>";

// variable declaration and assignment
$name   = "Aldo";
$age    = 25;          // int
$height = 1.76;        // float
$isEmployed = true;    // bool
$age += 1;

echo "My Name is $name and I am $age years old and my height is $height meters.";

echo "<br><br>";

// constant declaration
define('LOCATION_DIR_1', __DIR__);
define('LOCATION_DIR_2', __FILE__);
const PI = 3.14159;
echo "The value of PI is " . PI . " and the location directory is " . LOCATION_DIR_1 . "<br>";
echo "The value of PI is " . PI . " and the location directory is " . LOCATION_DIR_2 . "<br>";

echo "<br>";

// If else
if ($age >= 18) echo "Adult";
elseif ($age >= 13) echo "Teen";
else echo "Child";

echo "<br>";

switch (date('N')) {    // 1 (Mon) .. 7 (Sun)
    case 6:
    case 7:
        echo "Weekend";
        break;
    default:
        echo "Weekday";
}

echo "<br>";

// for loop
for ($i = 0; $i < 5; $i++) {
    echo $i;
}

echo "<br>";

// while
$i = 0;
while ($i < 5) {
    echo $i++;
}

echo "<br><br>";

// Function declaration and usage
function add(int $a, int $b): int
{
    return $a + $b;
}
echo add(3, 4); // 7

echo "<br>";
