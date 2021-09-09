export def eq lhs, rhs, msg = null
	console.log('comparing', lhs, rhs, msg ? "reason: {msg}" : '')
	return if lhs == rhs
	try
		console.log("{JSON.stringify(lhs)} is not equal {JSON.stringify(rhs)}")
	catch e
		console.log('failed to show comparison failure')
	process.exit(1)