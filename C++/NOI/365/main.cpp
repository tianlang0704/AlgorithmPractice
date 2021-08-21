#include <iostream>
#include <vector>
#include <map>
#include <algorithm>

using namespace std;

struct EdgeInfo {
    int vIn;
    int vOut;
    int length;
    int seaLevel;
};
vector<EdgeInfo> edgeInfoArr;

vector<EdgeInfo> FindEdge(int startV)
{
    vector<EdgeInfo> res;
    for(int i = 0; i < edgeInfoArr.size(); i++) {
        EdgeInfo edgeInfo = edgeInfoArr[i];
        if (edgeInfo.vIn == startV || edgeInfo.vOut == startV) {
            res.push_back(edgeInfo);
        }
    }
    return res;
}

int FindPath(int startV, int seaLevel)
{
    if (startV == 1) return 0;
    vector<EdgeInfo> conEdgeArr = FindEdge(startV);
    if (conEdgeArr.size() <= 0) return INT32_MAX;
    int shortestPath = INT32_MAX;
    for(int i = 0; i < conEdgeArr.size(); i++) {
        EdgeInfo conEdge = conEdgeArr[i];
        if (seaLevel >= conEdge.seaLevel) {
            seaLevel = INT32_MAX;
        }
        int pathLen = INT32_MAX;
        if (startV == conEdge.vIn) {
            pathLen = FindPath(conEdge.vOut, seaLevel);
        } else {
            pathLen = FindPath(conEdge.vIn, seaLevel);
        }
        if (pathLen < INT32_MAX && seaLevel >= conEdge.seaLevel) {
            pathLen = pathLen + conEdge.length;
        }
        if (pathLen < shortestPath) {
            shortestPath = pathLen;
        }
    }
    return shortestPath;
}

int main()
{
    int arrNum;
    cin >> arrNum;
    for (int j = 0; j < arrNum; j++) {
        int vertexNum, edgeNum;
        cin >> vertexNum >> edgeNum;
        edgeInfoArr.clear();
        for (int i = 0; i < edgeNum; i++) {
            int vIn, vOut, length, seaLevel;
            cin >> vIn >> vOut >> length >> seaLevel;
            EdgeInfo edgeInfo;
            edgeInfo.vIn = vIn;
            edgeInfo.vOut = vOut;
            edgeInfo.length = length;
            edgeInfo.seaLevel = seaLevel;
            edgeInfoArr.push_back(edgeInfo);
        }
        int lastAns = 0;
        int dayNum, K, maxSeaLevel;
        cin >> dayNum >> K >> maxSeaLevel;
        for (int i = 0; i < dayNum; i++) {
            int v0, p0;
            cin >> v0 >> p0;
            int dayStartV = (v0 + K * lastAns - 1) % vertexNum + 1;
            int daySeaLevel = (p0 + K * lastAns) % (maxSeaLevel + 1);
            lastAns = FindPath(dayStartV, daySeaLevel);
            // cout << lastAns << endl;
        }
    }
}


