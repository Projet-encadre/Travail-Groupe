function showTable(tableID) {
    document.querySelectorAll('.table').forEach(table => {
        table.classList.remove('active');
    });

    document.getElementById(tableID).classList.add('active');
    };
    
    window.onload = function() {
        document.getElementById('french').classList.add('active'); }