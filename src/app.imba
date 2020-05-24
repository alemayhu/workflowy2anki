const FileSaver = require('file-saver')

import ZipHandler from './handlers/ZipHandler'
import DeckHandler from './handlers/DeckHandler'
import ExpressionHelper from './handlers/ExpressionHelper'
import APKGBuilder from './handlers/APKGBuilder'

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
		const deck = DeckHandler.new().build(payload)
		const apkg = await APKGBuilder.new().build(null, deck, [file_name])
		self.packages.push({name: "{deck.name}.apkg", apkg: apkg, deck})
		self.cards = packages[0].deck.cards
		state = 'download'


	// TODO: refactor DRY
	def fileuploaded event
		try
			const files = event.target.files
			self.state = 'uploading'
			for file in files
				console.log('file', file)
				if file.name.match(/\.zip$/)
					const zip_handler = ZipHandler.new()
					const _ = await zip_handler.build(file)
					for file_name in zip_handler.filenames()
						if ExpressionHelper.document?(file_name)
							const deck = DeckHandler.new(file_name.match(/\.md$/)).build(zip_handler.files[file_name])
							const apkg = await APKGBuilder.new().build(null, deck, zip_handler.files)
							self.packages.push({name: "{file_name}.apkg", apkg: apkg, deck})
							self.cards = packages[0].deck.cards
							state = 'download'
			if packages.length == 0
				# Handle workflowy
				const file = files[0]
				const file_name = file.name
				console.log(file.toString())
				const reader = FileReader.new()
				reader.onload = do 
					const deck = DeckHandler.new(file_name.match(/\.md$/)).build(reader.result)
					const apkg = await APKGBuilder.new().build(null, deck, [file_name])
					self.packages.push({name: "{file_name}.apkg", apkg: apkg, deck})
					self.cards = packages[0].deck.cards
					state = 'download'
					imba.commit()
				reader.readAsText(file)

		catch e
			console.error(e)
			window.alert("Sorry something went wrong. Send this message to the developer. Error: {e.message}")		

	def downloadDeck
		for pkg in self.packages
			FileSaver.saveAs(pkg.apkg, pkg.name)
		state = 'ready'
	
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
