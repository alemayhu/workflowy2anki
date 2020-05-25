const FileSaver = require('file-saver')

import ZipHandler from './handlers/ZipHandler'
import DeckHandler from './handlers/DeckHandler'
import ExpressionHelper from './handlers/ExpressionHelper'

# Components
import './components/header'
import './components/footer'

# Pages
import './pages/contact-page'
import './pages/home-page'
import './pages/privacy-page'

tag app-root

	prop state = 'ready'
	prop progress = '0'
	prop info = ['Ready']
	prop packages = []

	def mount
		window.onbeforeunload = do
			if state != 'ready'
				return "Conversion in progress. Are you sure you want to stop it?"


	def pastedText event
		self.state = 'uploading'

		const payload = (event.clipboardData || window.clipboardData).getData('text')
		const file_name = 'virtual-name.txt'
		const deck = DeckHandler.new()
		await deck.build(payload)
		self.packages = await deck.apkg()
		state = 'download'


	// TODO: refactor DRY
	def fileuploaded event
		self.state = 'uploading'
		try
			const files = event.target.files

			if files.length > 1
				window.alert('Sorry only one file at a time, contact if this is annoying you')
				self.state = 'ready'
				return
			for file in files
				if file.name.match(/\.zip$/)
					const zip_handler = ZipHandler.new()
					const _ = await zip_handler.build(file)
					for file_name in zip_handler.filenames()
						if ExpressionHelper.document?(file_name)
							const deck = DeckHandler.new()
							await deck.build(zip_handler.files[file_name])
							self.packages = await deck.apkg()
							state = 'download'
			if packages.length == 0
				# Handle workflowy
				const file = files[0]
				const file_name = file.name
				console.log(file.toString())
				const reader = FileReader.new()
				reader.onload = do 
					const deck = DeckHandler.new()
					await deck.build(reader.result)
					self.packages = await deck.apkg()
					state = 'download'
					imba.commit()
				reader.readAsText(file)

		catch e
			console.error(e)
			window.alert("Sorry something went wrong. Send this message to the developer. Error: {e.message}")		

	def downloadDeck
		try
			for pkg in self.packages
				await FileSaver.saveAs(pkg.apkg, pkg.name)
		catch err
			window.alert('Sorry, something went wrong during opening. Have you allowed multi-file downloads?')
		state = 'ready'
		self.packages = []
	
	def render
		<self>
			<n2a-header>
			if window.location.pathname == '/contact'
				<contact-page>
			elif window.location.pathname == '/privacy'
				<privacy-page>
			else
				<home-page state=state>
			<n2a-footer>
