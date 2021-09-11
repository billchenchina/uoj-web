<?php
if (!function_exists('getenv_docker')) {
	function getenv_docker($env, $default) {
		if (($val = getenv($env)) !== false) {
			return $val;
		}
		else {
			return $default;
		}
	}
}

return [
	'profile' => [
		'oj-name' => 'Universal Online Judge',
		'oj-name-short' => 'UOJ',
		'administrator' => 'root',
		'admin-email' => 'admin@local_uoj.ac',
		'QQ-group' => '',
		'ICP-license' => ''
	],
	'database' => [
		'database' => getenv_docker('UOJ_DB_NAME', 'app_uoj233'),
		'username' => getenv_docker('UOJ_DB_USER', 'root'),
		'password' => getenv_docker('UOJ_DB_PASSWORD', 'root'),
		'host' => getenv_docker('UOJ_DB_HOST', 'mysql')
	],
	'web' => [
		'domain' => null,
		'main' => [
			'protocol' => 'http',
			'host' => UOJContext::httpHost(),
			'port' => 80
		],
		'blog' => [
			'protocol' => 'http',
			'host' => UOJContext::httpHost(),
			'port' => 80
		]
	],
	'security' => [
		'user' => [
			'client_salt' => 'salt0'
		],
		'cookie' => [
			'checksum_salt' => ['salt1', 'salt2', 'salt3']
		],
	],
	'mail' => [
		'noreply' => [
			'username' => 'noreply@local_uoj.ac',
			'password' => '_mail_noreply_password_',
			'host' => 'smtp.local_uoj.ac',
			'secure' => 'tls',
			'port' => 587
		]
	],
	'judger' => [
		'socket' => [
			'port' => '2333',
			'password' => '_judger_socket_password_'
		]
	],
	'switch' => [
		'web-analytics' => false,
		'blog-domain-mode' => 3
	]
];
