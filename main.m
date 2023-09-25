Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 1);

fname = 'instructions.txt';
fid = fopen(fname, 'r');
myText = fscanf(fid, '%c');
fclose(fid);


sound1 = MakeBeep(75, 2, 4800); %kalın
sound2 = MakeBeep(150, 2, 4800); %orta
sound3 = MakeBeep(450, 2, 4800); %ince
rng('shuffle')
sound_conditions = [ones(1, 16) ones(1, 16) * 2 ones(1, 16) * 3];
shuffled_conditions = Shuffle(sound_conditions);
condition_assignment = shuffled_conditions(randperm(length(sound_conditions)));

stimulus = 'BCDFGHJKLMNPQRSTUVWXYZ';

index_2x3 = randperm(length(stimulus), 6);
index_2x4 = randperm(length(stimulus), 8);
index_3x3 = randperm(length(stimulus), 9);
index_3x4 = randperm(length(stimulus), 12);

stimulus_2x3 = reshape(stimulus(index_2x3), [2, 3]); %condition_number 1
stimulus_2x4 = reshape(stimulus(index_2x4), [2, 4]); %condition_number 2
stimulus_3x3 = reshape(stimulus(index_3x3), [3, 3]); %condition_number 3
stimulus_3x4 = reshape(stimulus(index_3x4), [3, 4]); %condition_number 4

rng('shuffle')
stimulus_conditions = [ones(1, 12) ones(1, 12) * 2 ones(1, 12) * 3 ones(1, 12) * 4]; %uyarıcı kosullarını olusturuyoruz
shuffled_stimulus_conditions = Shuffle(stimulus_conditions); %uyarıcı kosullarını shuffle ediyoruz


Screen('Preference', 'VisualDebugLevel', 0);
[myWindow, rect] = Screen('OpenWindow', 1, [255 255 255]);
centerX = rect(3) / 2;
centerY = rect(4) / 2;

Screen('TextSize', myWindow, 50);
DrawFormattedText(myWindow, myText, 'center', centerY - 100, [0 0 0]);
Screen('Flip', myWindow)
KbWait;


[normBoundsRect,offsetBoundsRect]=Screen('TextBounds',myWindow,	'İNCE SESİ DİNLİYORSUNUZ');	
% Ses tanıtımları
Screen('TextSize', myWindow, 50);
Screen('DrawText', myWindow, 'İNCE SESİ DİNLİYORSUNUZ', centerX-normBoundsRect(3)/2,centerY-normBoundsRect(4)/2, [0 0 0]);
Screen('Flip', myWindow)
sound(MakeBeep(450, 5, 4800)); 
WaitSecs(5)


Screen('TextSize', myWindow, 50);
Screen('DrawText', myWindow, 'ORTA SESİ DİNLİYORSUNUZ', centerX-normBoundsRect(3)/2,centerY-normBoundsRect(4)/2, [0 0 0]);
Screen('Flip', myWindow)
sound(MakeBeep(150, 5, 4800));
WaitSecs(5)

Screen('TextSize', myWindow, 50);
Screen('DrawText', myWindow, 'KALIN SESİ DİNLİYORSUNUZ', centerX-normBoundsRect(3)/2,centerY-normBoundsRect(4)/2, [0 0 0]);
Screen('Flip', myWindow)
sound(MakeBeep(75, 5, 4800));
WaitSecs(5)

% Alıştırma denemeleri
train(10) %10 trail

[myWindow, rect] = Screen('OpenWindow', 1, [255 255 255]);

text = 'Alıştırma denemeleri bitti. Deneye başlamaya hazır olduğunuzda herhangi bir tuşa basarak deneyi başlatabilirsiniz.';
Screen('TextSize', myWindow, 50);
DrawFormattedText(myWindow, text, 'center', centerY - 100, [0 0 0]);
Screen('Flip', myWindow)

KbWait;

% Ana deney döngüsü
condition_counter = 0;
stimulus_cell = {}; %gösterilen stimulusları kaydediyoruz
report_answer = {};
while condition_counter < 50
    for i = 1:length(shuffled_stimulus_conditions)
        Screen('Preference', 'VisualDebugLevel', 0); %PTB Mor ekranını kaldırıyoruz.
        [myWindow, rect] = Screen('OpenWindow', 1, [255 255 255]);
        [xCenter, yCenter] = RectCenter(rect);
        crossLength = 100;
        crossWidth = 4;
        crossColor = [0, 0, 0];
        horizontalLine = [xCenter - crossLength, xCenter + crossLength, xCenter, xCenter];
        verticalLine = [yCenter, yCenter, yCenter - crossLength, yCenter + crossLength];
        
        Screen('DrawLines', myWindow, [horizontalLine; verticalLine], crossWidth, crossColor);
        Screen('Flip', myWindow);
        WaitSecs(3);
        
        results = cell(size(stimulus_2x3,1), 1); %sonucun 1.sütununu alıyoruz
        if shuffled_stimulus_conditions(i) == 1
            % Uyarıcıları gösterdigimiz kısım
            for j = 1:size(stimulus_2x3, 1)
                result = sprintf('%s', Shuffle(stimulus_2x3(j, 1:3)));
                results{j} = result;
            end
        
        elseif shuffled_stimulus_conditions(i) == 2
            for j = 1:size(stimulus_2x4, 1)
                result = sprintf('%s', Shuffle(stimulus_2x4(j, 1:4)));
                results{j} = result;
            end
        
        elseif shuffled_stimulus_conditions(i) == 3
            for j = 1:size(stimulus_3x3, 1)
                result = sprintf('%s', Shuffle(stimulus_3x3(j, 1:3)));
                results{j} = result;
            end
        
        else
            for j = 1:size(stimulus_3x4, 1)
                result = sprintf('%s', Shuffle(stimulus_3x4(j, 1:4)));
                results{j} = result;
            end
        end
        
        xPosition = rect(3) / 2;
        yPosition = rect(4) / 2;
        lineSpacing = 80;
        
        Screen('TextSize', myWindow, 50);
        for k = 1:length(results)
            yPos = yPosition + (k - 2) * lineSpacing;
            DrawFormattedText(myWindow, results{k}, 'center', yPos, [0 0 0]);
        end
        Screen('Flip', myWindow);
        WaitSecs(0.5)
        
        for s = condition_assignment(i) %koşullara göre sesleri çaldırıyoruz
            if s == 1
                sound(sound1);
            elseif s == 2
                sound(sound2);
            elseif s == 3
                if size(results) == 3
                    sound(sound1 | sound2);
                else
                    sound(sound3);
                end
                    
            end
        end
        
        Screen('TextSize', myWindow, 50);
        DrawFormattedText(myWindow, 'Sound', xPosition, yPosition, [255 255 255])
        Screen(myWindow, 'Flip');
        WaitSecs(2)
        
        Screen('CloseAll');
        
        %raporlama kısmı
        answer = input('RAPORUNUZU GİRİNİZ (Deneyden çıkmak isterseniz q tuşlayınız):', 's');
        if answer == 'q' 
            condition_counter = 50;
        end
        
        report_answer{end+1} = answer;

        condition_counter = condition_counter + 1;
        
       
        
        for s = 1:length(results)
                %Eğer stimulus hücre dizisinin boyutunu aşmadıysak ekliyoruz
            if s <= length(stimulus_cell)
                stimulus_cell{s} = results{s};
            else
                % Eğer stimulus hücre dizisinin boyutunu aşıyorsa yeni bir
                % hücre ekliyoruz
                stimulus_cell{end+1} = results{s};
            end
        end


        if condition_counter >= 50
            break;
        end
    end
end
