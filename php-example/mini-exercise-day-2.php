<?php

// always enable strict mode
declare(strict_types=1);

// Build a Cart class that holds items (name, qty, price) and can compute total.
class Cart
{
    public function __construct(
        public string $name,
        public int $qty,
        public float $price
    ) {}

    public function cost(): float
    {
        return $this->qty * $this->price;
    }
}

$total = new Cart("Bottle", 100, 5000);
echo "Total Cost = ", $total->cost();

echo "<br><br>";

// Parse a CSV (id,name,qty) into array of objects.
$csvData = "1,Apple,10\n2,Banana,20\n3,Cherry,30";
$lines = explode("\n", $csvData);
$items = [];
foreach ($lines as $line) {
    list($id, $name, $qty) = explode(',', $line);
    $items[] = (object) ['id' => (int)$id, 'name' => $name, 'qty' => (int)$qty];
}
echo "<pre>";
print_r($items);
echo "</pre>";

echo "<br><br>";

// Read JSON file → associative array → pretty-print as HTML table.
$jsonData = '[{"id":1,"name":"Apple","qty":10},{"id":2,"name":"Banana","qty":20},{"id":3,"name":"Cherry","qty":30}]';
$dataArray = json_decode($jsonData, true);
echo "<table border='1'>";
echo "<tr><th>ID</th><th>Name</th><th>Qty</th></tr>";
foreach ($dataArray as $item) {
    echo "<tr>";
    echo "<td>{$item['id']}</td>";
    echo "<td>{$item['name']}</td>";
    echo "<td>{$item['qty']}</td>";
    echo "</tr>";
}
echo "</table>";
