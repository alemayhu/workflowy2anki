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
			<page-content .justify-center=(state == 'uploading') .items-center=(state == 'uploading')>
				if state == 'ready'
					<div>
						<p .py-6 .text-center .text-xl>
							"Convert Workflowy "
							<a .text-blue-700 .underline href="https://www.youtube.com/watch?v=CSmbnaPZVHE"> "outlines "
							" to Anki cards easily."
						<div .h-32 .flex .items-center .justify-center :click.clickButton>
							<n2a-button> "Upload Workflowy export"
							<input #upload-button .hidden :change.fileuploaded type="file" name="resume" accept=".zip,.html">
						<div .flex .items-center .justify-center .flex-col>
							<h2 .font-bold .text-4xl> "or Paste"
							<div>
								<textarea[pasted] .border-solid .m-4 .border-2 .border-gray-600>
						<.flex .flex-col .items-center>
							<h2 .font-bold .text-4xl>
								<a href="#usage" name="usage"> "How it works"
							<iframe .self-center width="560" height="315" src="https://www.youtube.com/embed/b3eQ0exhdz4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>						
				elif state == 'uploading'
					<div .flex .flex-col .justify-center .items-center .h-screen>
						<h2 .text-4xl> "One moment, building your deck 👷🏾‍♀️"
				elif state == 'download'
					<div .flex .flex-col .justify-center .items-center .h-screen>
						<h3 .text-xl .p-2> "Your deck is ready to. Download it and import it into Anki"
						<n2a-button :click.downloadDeck> "Download"
						<p .text-center .p-4 .text-lg> "Would you like to help make Workflowy 2 Anki better? Your feedback is very appreciated 🙇🏾‍♂️"
						<a .bg-green-400 .px-2 .mx-4 target="_blank" href="https://alexander208805.typeform.com/to/wMSzba"> "Give feedback"