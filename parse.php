<?php

$version = $argv[1];
$topic = $argv[2];
$scope = 'vtiger-core/'.$argv[3];
$topicInfo = 'docs/'.$topic.'.json';

/**
 * @param $version
 * @param $scope
 */
function parseScope($version, $scope, &$info) {
    if (is_dir($scope)) {
        foreach (scandir($scope) as $dir) {
            if ($dir[0] !== '.') {
                parseScope($version, $scope.'/'.$dir, $info);
            }
        }
    } elseif (file_exists($scope)) {
        parseFile($version, $scope, $info);
    } else {
        die('Scope not found');
    }
}

/**
 * @param $version
 * @param $file
 */
function parseFile($version, $file, &$info)
{
    $extension = pathinfo($file, PATHINFO_EXTENSION);
    if ($extension === 'php') {
        $source = file_get_contents($file);
        preg_match_all('/class ([a-z]+)/i', $source, $data);
        foreach ($data[0] as $index => $header) {
            list($before) = str_split($source, strpos($source, $header));
            $line = strlen($before) - strlen(str_replace("\n", "", $before)) + 1;
            echo "FILE: [{$version}] {$file}:{$line} {$data[1][$index]}\n";
        }
        preg_match_all('/function ([a-z]+)/i', $source, $data);
        foreach ($data[0] as $index => $header) {
            list($before) = str_split($source, strpos($source, $header));
            $line = strlen($before) - strlen(str_replace("\n", "", $before)) + 1;
            echo "FILE: [{$version}] {$file}:{$line} {$data[1][$index]}\n";
        }
    }
}

$info = [];
parseScope($version, $scope, $info);

var_dump($info);
