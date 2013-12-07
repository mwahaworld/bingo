#
#  bingo client for Yahoo! bingo
#

socketIO = io.connect 'ws://yahoobingo.herokuapp.com'
bingoWin =
	B: [0,0,0,0,0],
	I: [0,0,0,0,0],
	N: [0,0,0,0,0],
	G: [0,0,0,0,0],
	O: [0,0,0,0,0]

socketIO.on 'connect', ->
	socketIO.emit 'register',
		name: 'Kun-Li Chen'
		email: 'kunlichen@gmail.com'
		url: 'https://github.com/mwahaworld/bingo'

socketIO.on 'card', (payload)=>
	#debug
	console.log 'board', payload

	#store the board
	@board = payload.slots

socketIO.on 'number', (bingoNum)=>
	#debug
	letter = bingoNum.substring(0,1)
	number = bingoNum.substring(1)
	console.log letter + ' ' + number
	currentBoardColumn = board.B
	bingoWinColumn = bingoWin.B

	switch letter
		when 'I'
			currentBoardColumn = board.I
			bingoWinColumn = bingoWin.I
		when 'N'
			currentBoardColumn = board.N
			bingoWinColumn = bingoWin.N
		when 'G'
			currentBoardColumn = board.G
			bingoWinColumn = bingoWin.G
		when 'O'
			currentBoardColumn = board.O
			bingoWinColumn = bingoWin.O
		else return null

	for i in [0..4]
		if currentBoardColumn[i].toString() is number
			console.log 'match ' + number + ' found in: ' + letter + ' row: ' + i
			bingoWinColumn[i] = parseInt(number)
			console.log bingoWin

			#win conditions
			#column

			if bingoWinColumn.length is 5
				#top down
				if bingoWinColumn[0] isnt 0\
				and bingoWinColumn[1] isnt 0\
				and bingoWinColumn[2] isnt 0\
				and bingoWinColumn[3] isnt 0\
				and bingoWinColumn[4] isnt 0
					console.log 'bingo column'
					socketIO.emit 'bingo'

			#row
			for r in [0..4]
				if bingoWin.B.length >= bingoWinColumn.length and bingoWin.B[r] isnt 0\
				and bingoWin.I.length >= bingoWinColumn.length and bingoWin.I[r] isnt 0\
				and bingoWin.N.length >= bingoWinColumn.length and bingoWin.N[r] isnt 0\
				and bingoWin.G.length >= bingoWinColumn.length and bingoWin.G[r] isnt 0\
				and bingoWin.O.length >= bingoWinColumn.length and bingoWin.O[r] isnt 0
					console.log 'bingo row'
					socketIO.emit 'bingo'

			#diagnal \
			if bingoWin.B[0] isnt 0\
			and bingoWin.I[1] isnt 0\
			and bingoWin.N[2] isnt 0\
			and bingoWin.G[3] isnt 0\
			and bingoWin.O[4] isnt 0
				console.log 'bingo diagnal 0..4'
				socketIO.emit 'bingo'

			#diagnal /
			if bingoWin.B[4] isnt 0\
			and bingoWin.I[3] isnt 0\
			and bingoWin.N[2] isnt 0\
			and bingoWin.G[1] isnt 0\
			and bingoWin.O[0] isnt 0
				console.log 'bingo diagnal 4..0'
				socketIO.emit 'bingo'

socketIO.on 'win', (message)->
	console.log 'win', message
socketIO.on 'lose', (message)->
	console.log 'lose', message
socketIO.on 'disconnect', ()->
	console.log 'disconnect'