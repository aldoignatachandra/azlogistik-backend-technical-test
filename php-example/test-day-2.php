<?php

// always enable strict mode
declare(strict_types=1);

// 1 . Arrays
$nums = [10, 20, 30];
$user = ['id' => 1, 'name' => 'Aldo'];

foreach ($nums as $n) {
    echo "$n ";
}

echo "<br><br>x ";

foreach ($user as $k => $v) {
    echo "$k : $v <br>";
}

echo "<br>";

array_push($nums, 40);
echo count($nums);

echo "<br><br>";

// 2 . Useful array helpers
$squared = array_map(fn($n) => $n ** 2, $nums);
$filtered = array_filter($nums, fn($n) => $n > 15);
$sum = array_sum($nums);

echo "<pre>squared = ";
print_r($squared);
echo "</pre>";

echo "<pre>filtered = ";
print_r($filtered);
echo "</pre>";

echo "sum = $sum";

echo "<br><br>";

// 3 . Strings
$str = "logistics company";
echo strtoupper($str), "<br>";
echo str_replace("company", "corp", $str), "<br>";
echo sprintf("Salary: \$%0.2f", 1234.5), "<br>";

echo "<br><br>";

// 4 . File I/O
$data = file_get_contents('data.txt');
file_put_contents('log.txt', $data, FILE_APPEND);

echo "<br><br>";

// 5. Intro to OOP
class Package
{
    public function __construct(
        public int $id,
        public float $weight
    ) {}

    public function cost(): float
    {
        return $this->weight * 1.2;
    }
}

$p = new Package(1001, 3.5);
echo $p->cost();

echo "<br><br>";
