% Michael Chen - September 22, 2023
% This script generates a CSV for PA aileron sizing

%% Straight Aileron
%{
The plane has an aileron with a straight hinge or constant chord hinge
The aileron ends at the 90% of the half span

Constants are
- Aileron End Position
- Aileron End Chord

Parameters to modify are
- Total aileron span / wingspan (0.35)
- Aileron chord / chord at aileron end (0.35)

Output
- aileron start (x)
- aileron start chord
- aileron start hinge 
- aileron end hinge
%}

clear

useMeters = true;

rootX = 5.094478;
rootChord = 24;
tipChord = 12;
wingspan = 9.95 * 12;
aileronEndSpanFrac = 0.9;

aileronSpanPerWingspan = 0.35;
aileronChordPerWingChord = 0.35;

numRunCases = length(aileronSpanPerWingspan) * length(aileronChordPerWingChord);
disp(strcat("Num run cases = ", string(numRunCases)));

[aileronSpanPerWingspan, aileronChordPerWingChord] = ndgrid(aileronSpanPerWingspan, aileronChordPerWingChord);

if useMeters
    rootX = rootX / 39.37;
    rootChord = rootChord / 39.37;
    tipChord = tipChord / 39.37;
    wingspan = wingspan / 39.37;
end

% Aileron start x defined by linear function
aileronStartY = (wingspan / 2) * (aileronEndSpanFrac - aileronSpanPerWingspan);

% Aileron end x is constant
aileronEndX = (wingspan / 2) * (aileronEndSpanFrac);

% Aileron start chord is defined by linear function
aileronStartChord = (tipChord - rootChord) / (wingspan / 2 - rootX) * (aileronStartY - rootX) + rootChord;

% Aileron end chord is constant
aileronEndChord = (tipChord - rootChord) / (wingspan / 2 - rootX) * (aileronEndX - rootX) + rootChord;

% Aileron end hinge is the chord location where the aileron starts represented as a fraction from the leading edge 
aileronEndHinge = 1 - aileronChordPerWingChord;

% Aileron end hinge in units of length from the leading edge
aileronEndHingePos = aileronEndChord * aileronEndHinge;

% Aileron start hinge calculated from the position from the leading edge
aileronStartHinge = aileronEndHingePos ./ aileronStartChord;

% Total aileron area is two trapezoids, one for each control surface
% Straight is for straight hinge and constant is for constant chord hinge
totalAileronAreaStraight = (aileronEndX - aileronStartY) .* ((aileronStartChord - aileronStartChord .* aileronStartHinge) + (aileronEndChord - aileronEndChord .* aileronEndHinge));
totalAileronAreaConstant = (aileronEndX - aileronStartY) .* ((aileronStartChord - aileronStartChord .* aileronEndHinge) + (aileronEndChord - aileronEndChord .* aileronEndHinge));

% Reshape the matrices into column vectors
aileronStartY = reshape(aileronStartY, [], 1);
aileronStartChord = reshape(aileronStartChord, [], 1);
aileronStartHinge = reshape(aileronStartHinge, [], 1);
aileronEndHinge = reshape(aileronEndHinge, [], 1);
totalAileronAreaStraight = reshape(totalAileronAreaStraight, [], 1);
totalAileronAreaConstant = reshape(totalAileronAreaConstant, [], 1);
aileronSpanPerWingspan = reshape(aileronSpanPerWingspan, [], 1);
aileronChordPerWingChord = reshape(aileronChordPerWingChord, [], 1);

% Output a CSV
output = round([aileronStartY, aileronStartChord, aileronStartHinge, aileronEndHinge, totalAileronAreaStraight, totalAileronAreaConstant, aileronSpanPerWingspan, aileronChordPerWingChord], 4);
T = array2table(output);
T.Properties.VariableNames = ["aileronStartY", "aileronStartChord", "aileronStartHinge", "aileronEndHinge", "totalAileronAreaStraight", "totalAileronAreaConstant", "aileronSpanPerWingspan", "aileronChordPerWingChord"];
writetable(T, 'MX-9_StraightAileron.csv');