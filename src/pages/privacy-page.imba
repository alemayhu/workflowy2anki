import '../components/page-content'

tag privacy-page
	<self>
		<page-content>
			<div css:max-width="720px" css:margin="0 auto" .py-4>
				<div .flex .flex-col .items-center>
					<h2 .text-4xl>
						<a href="#privacy" name="privacy"> "Privacy Protection"
					<p .py-2 .text-xl>
						"In case you are worried about privacy, let me explain how this site runs:"
						<br>
						<strong> "This tool is a static site which runs totally on your browser."
					<p .py-2 .text-xl>
						"That means all of the file handling is done on "
						<strong> "your machine"
						", I never see any of it. "
						<br>
						"You can also read the source code at "
						<a .text-blue-600 href="https://github.com/alemayhu/workflowy2anki"> "alemayhu/workflowy2anki"
					<div>
						<h2 .text-2xl .font-bold> "Hosting"
						<p .py-2 .text-xl> 
							"This site is being served via"
							<a href="https://netlify.com"> " Netlify"
							". You can read their privacy policy here "
							<a .text-blue-600 href="https://www.netlify.com/privacy/"> "https://www.netlify.com/privacy/"
					<div>
						<h2 .text-2xl .font-bold> "Error Reporter"
						<p .py-2 .text-xl> 
							"This site uses Sentry for crash reports. You can read their privacy policy here "
							<a .text-blue-600 href="https://sentry.io/privacy/"> "https://sentry.io/privacy/"
					<div>
						<h2 .text-2xl .font-bold> "Analytics"
						<p .py-2 .text-xl> 
							"In order to better understand the usage (number of visitors) of the site and how to better serve users, Google Analytics is used."
							"See their privacy policy here "
							<a .text-blue-600 href="https://policies.google.com/privacy"> "https://policies.google.com"

				