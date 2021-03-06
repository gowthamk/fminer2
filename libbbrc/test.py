import bbrc
MyFminer = bbrc.Bbrc()
# Toy example: special settings for mining all fragments
# use no significance constraint
MyFminer.SetChisqSig(0) 
# refine structures with support 1
MyFminer.SetRefineSingles(1) 
MyFminer.SetConsoleOut(0)
# Add compounds below. IMPORTANT! DO NOT CHANGE SETTINGS AFTER ADDING COMPOUNDS!
MyFminer.AddCompound("COC1=CC=C(C=C1)C2=NC(=C([NH]2)C3=CC=CC=C3)C4=CC=CC=C4" , 1)
MyFminer.AddCompound("O=C1NC(=S)NC(=O)C1C(=O)NC2=CC=CC=C2" , 2)
# ... continue adding compounds
MyFminer.AddActivity(1.0, 1)
MyFminer.AddActivity(0.0, 2)
# ... continue adding activities (true for active, false for inactive)
print repr(MyFminer.GetNoCompounds()) + ' compounds.'
# gather results for every root node in vector instead of immediate output
for j in range(0, MyFminer.GetNoRootNodes()):
     result = MyFminer.MineRoot(j);
     for i in range(0, result.size()):
                 print result[i];
