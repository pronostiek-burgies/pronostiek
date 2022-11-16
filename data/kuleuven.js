// ['ARG', 'AUS', 'BEL', 'BRA', 'CAN', 'CMR', 'CRC', 'CRO', 'DEN', 'ECU', 'ENG', 'ESP', 'FRA', 'GER', 'GHA', 'IRN', 'JPN', 'KOR', 'KSA', 'MAR', 'MEX', 'NED', 'POL', 'POR', 'QAT', 'SEN', 'SRB', 'SUI', 'TUN', 'URU', 'USA', 'WAL']

let matches = {}
document.getElementById("viz-score-matrix").parentNode.addEventListener("DOMSubtreeModified", () => {
    let node = document.getElementById("viz-score-matrix").parentNode;
    if (node.children[node.children.length-1].innerHTML.length == 0) {return;}
    let k = [[],[],[],[],[],[]]
    let home = document.getElementById("home-team-select").value
    let away = document.getElementById("away-team-select").value
    for (let i in [0,1,2,3,4,5]) {
        for (let j in [0,1,2,3,4,5]) {
            k[i][j] = parseFloat(document.getElementById("cell("+i+","+j+")").attributes.data.nodeValue)
        }
    }
    matches[home+"-"+away] = k
})
