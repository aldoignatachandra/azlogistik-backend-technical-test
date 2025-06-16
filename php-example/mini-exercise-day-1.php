<?php

// always enable strict mode
declare(strict_types=1);

// Write fizzbuzz.php (1-100)
for ($i = 1; $i <= 100; $i++) {
    if ($i % 3 === 0 && $i % 5 === 0) {
        echo "FizzBuzz";
    } elseif ($i % 3 === 0) {
        echo "Fizz";
    } elseif ($i % 5 === 0) {
        echo "Buzz";
    } else {
        echo $i;
    }
    echo " ";
}

// Make a function circleArea(float $r): float
function circleArea(float $r): float
{
    return pi() * $r * $r;
}


// Output the larger of three numbers using nested if
function maxOfThree(float $a, float $b, float $c): float
{
    if ($a > $b) {
        if ($a > $c) return $a;
        else return $c;
    } else {
        if ($b > $c) return $b;
        else return $c;
    }
}
