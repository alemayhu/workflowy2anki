import '../components/page-content'
import '../components/n2a-button'

tag home-page

	prop state = 'ready'
	prop pasted = ''

	def clickButton
		const button = document.getElementById('upload-button')
		button.click()
		
	def render
		<self>
			<page-content .(p:4 display:block) .justify-center=(state == 'uploading') .items-center=(state == 'uploading')>
				if state == 'ready'
					<p .py-6 .text-center .text-xl>
						"Convert "
						<a .text-blue-600 href="http://workflowy.com/"> "WorkFlowy "
						<a .text-black .underline href="https://www.youtube.com/watch?v=CSmbnaPZVHE"> "outlines "
						" to Anki cards easily."
					<div .h-32 .flex .items-center .justify-center :click.clickButton>
						<n2a-button> "Upload WorkFlowy export"
						<input #upload-button .hidden :change.fileuploaded type="file" name="resume" accept=".txt">
					# <div .flex .items-center .justify-center .flex-col>
					# 	<h2 .text-2xl> "Alternatively paste below"
					# 	<div .textarea-container>
					# 		<textarea[pasted] :paste.pastedText>
					<.flex .flex-col .items-center css:width="70vw" css:margin="0 auto">
						<div.(p:4)>
							<h2 .font-bold .text-4xl .text-center> 
								<a href="#usage" name="usage"> "How it works"
							<p .text-2xl> 
								"Below is a screenshot that guides you on how to create decks with this tool. Follow the format and upload when ready."
						<div>
							<img src="/how.png">
						<p>
							"Thanks to "
							<a.(color:blue600) href="https://www.youtube.com/channel/UCKUlFNpjdVi1SBlKvGFH_7A"> "Jason Able"
							" for making the image."
				elif state == 'uploading'
					<div .flex .flex-col .justify-center .items-center .h-screen>
						<h2 .text-4xl> "One moment, building your deck 👷🏾‍♀️"
				elif state == 'download'
					<div .flex .flex-col .justify-center .items-center .h-screen>
						<h3 .text-xl .p-2> "Your deck is ready to. Download it and import it into Anki"
						<n2a-button :click.downloadDeck> "Click to Open"
