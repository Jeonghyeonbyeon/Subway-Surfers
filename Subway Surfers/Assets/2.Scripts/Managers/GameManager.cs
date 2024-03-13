using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    [SerializeField] private Text scoreText;
    [SerializeField] private Text squareText;
    [SerializeField] private Text goldText;
    private int score;
    private int square = 1;
    public int gold = 0;

    private void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        scoreText.text = $"{score}";
        squareText.text = $"x{square}";
        goldText.text = $"{gold}";
    }

    void FixedUpdate()
    {
        score += Mathf.Clamp(square, 1, 20);

        ScoreUpdate();
        SquareUpdate();
        GoldUpdate();
    }

    void ScoreUpdate() => scoreText.text = $"{score}";

    void SquareUpdate() => squareText.text = $"x{square = Mathf.Clamp(square, 1, 20)}";

    void GoldUpdate() => goldText.text = $"{gold}";
}
