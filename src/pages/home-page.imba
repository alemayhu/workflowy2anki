import '../components/page-content'
import '../components/n2a-button'

tag home-page

	prop state = 'ready'
	prop pasted = ''

	def clickButton
		const button = document.getElementById('upload-button')
		button.click()
	
	def pastedText event
		const payload = (event.clipboardData || window.clipboardData).getData('text')
		console.log('pasted Text', JSON.stringify(payload))
	
	def render
		<self>
			<page-content .justify-center=(state == 'uploading') .items-center=(state == 'uploading')>
				if state == 'ready'
					<p .py-6 .text-center .text-xl>
						"Convert WorkFlowy "
						<a .text-blue-700 .underline href="https://www.youtube.com/watch?v=CSmbnaPZVHE"> "outlines "
						" to Anki cards easily."
					<div>
						<div .h-32 .flex .items-center .justify-center :click.clickButton>
							<n2a-button> "Upload WorkFlowy export"
							<input #upload-button .hidden :change.fileuploaded type="file" name="resume" accept=".zip,.html">
						<div .flex .items-center .justify-center .flex-col>
							<h2 .text-2xl> "Alternatively paste below"
							<div .textarea-container>
								<textarea[pasted] onpaste=pastedText>
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
						<p .text-center .p-4 .text-lg> "Would you like to help make WorkFlowy 2 Anki better? Your feedback is very appreciated 🙇🏾‍♂️"
						<a .bg-green-400 .px-2 .mx-4 target="_blank" href="https://alexander208805.typeform.com/to/wMSzba"> "Give feedback"