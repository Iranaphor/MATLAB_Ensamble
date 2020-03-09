clc, clear
%Set random seed
rng(1)

%Property Definition
XLIM = 3; %World Limits
YLIM = 4;
TOTAL_ACTIONS = 100;

%Generate world
score = zeros(XLIM,YLIM);
world = repmat('+',XLIM,YLIM);

%Plot Scoring Locations
% mines = [randi(XLIM,5,1),randi(YLIM,5,1)];
mines = [2,4];
for i=1:size(mines,1)
    score(mines(i,1),mines(i,2))=-100;
    world(mines(i,1),mines(i,2))='M';
end

walls = [2,2];
for i=1:size(walls,1)
    score(walls(i,1),walls(i,2))=-Inf;
    world(walls(i,1),walls(i,2))='W';
end


%Plot Stat and End Locations
startpoint = [XLIM,1];
score(startpoint(1),startpoint(2))=0;
world(startpoint(1),startpoint(2))='S';

endpoint = [1,YLIM];
score(endpoint(1),endpoint(2))=100;
world(endpoint(1),endpoint(2))='E';

%Display Q-Table
actions = {'U','R','D','L'};
states = num2cell(unique(world)');
types = repmat({'double'},1,size(actions,2));
QTable = table('Size',[size(states,2),size(actions,2)],...
    'VariableTypes',types,'VariableNames',actions,'RowNames',states);


%Generate list of actions
action_list = randi(4,1,TOTAL_ACTIONS); 
action_list(action_list==1)=85;
action_list(action_list==2)=68;
action_list(action_list==3)=82;
action_list(action_list==4)=76;

%Define startpoint
oldpos = startpoint;
display_state(oldpos, world, score, QTable, action_list, 0)

%Loop through the actions and update the QTable
for i=1:length(action_list)
    action = action_list(i); %Choose Action
    newpos = move(oldpos,action,world); %Move
    QTable = QFunction(oldpos,action,newpos,score,world,QTable); %Update Weights 
    oldpos = newpos; %Uppdate Position
    display_state(newpos, world, score, QTable, action_list,i); %Display New State
end




function newpos = move(pos,action,world)
    [w,h]=size(world);
    newpos = pos;
    
    switch action
        case 'U'
            if pos(1)>1,newpos(1)=pos(1)-1; end
        case 'R'
            if pos(2)<h,newpos(2)=pos(2)+1; end
        case 'D'
            if pos(1)<w,newpos(1)=pos(1)+1; end
        case 'L'
            if pos(2)>1,newpos(2)=pos(2)-1; end
    end
    
    if world(newpos(1),newpos(2))=='W'
        disp("shiiiet")
        newpos = pos;
    end
end

function QTable = QFunction(oldpos,action,newpos,score,world,QTable)
    %{
    Q Values define Maximum Expected Rewards given an action & state
    we calculate the update step by reward+discount*maxpossible-current
    update the current Q Value
    %}
    a = char(action);
    s = world(newpos(1),newpos(2));

    Qsa = QTable{s,a}; %Current value
    
    LR = 0.1; %Learning Rate
    R = score(newpos(1),newpos(2)); %Reward
    Y = 0.1; %Discount Factor
    
    
    potential = find((cell2mat(QTable.Row))~=s);
    
    oldcentre = world(oldpos(1),oldpos(2));
    maxQ = max(findactionresult(score, oldpos, QTable)); %Maximum expected future reward
        
    dQsa = LR.*(R+(Y.*maxQ)-Qsa); %QValue Update Step
    
    QTable{s,a} = Qsa + dQsa; %Update value in table
end

function results = findactionresult(score, oldpos, QTable)
    
    results = nan(1,length(QTable.Row));
    [w,h]=size(score);
    if oldpos(1)>1,results(1)=score(oldpos(1)-1,oldpos(2));end %U
    if oldpos(2)<h,results(2)=score(oldpos(1),oldpos(2)+1);end %R
    if oldpos(1)<w,results(3)=score(oldpos(1)+1,oldpos(2));end %D
    if oldpos(2)>1,results(4)=score(oldpos(1),oldpos(2)-1);end %L
end


function display_state(pos, world, score, qtable, action_list, i)
    clc
    disp(newline+"World Layout")
    world(pos(1),pos(2))='X';
    disp(""+world);
    
    disp(newline+"Score Map (entitiy defined by NaN)")
    score(pos(1),pos(2))=nan;
    disp(score);

    disp(newline + "QTable")
    disp(qtable)
    
    if i ~= 0
        disp(newline+"Remaining Actions")
        disp(char([action_list(1:i),' ',action_list(i+1:end)]))
        disp([repmat(' ',1,i-1),'  ^  <-- next action'])
    end
    
    pause(1)
end



